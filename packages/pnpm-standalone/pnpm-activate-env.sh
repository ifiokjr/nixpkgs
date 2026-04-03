#!/usr/bin/env bash
set -euo pipefail

usage() {
	cat <<'EOF'
Usage: pnpm-activate-env [--print-export] [--workspace-file <path>]

Reads useNodeVersion from a pnpm workspace file and prepares PATH for that Node.js version.

Options:
  --print-export         Print shell code that updates PATH (use with eval).
  --workspace-file PATH  Use a specific workspace file instead of searching parent directories.
  -h, --help             Show this help message.
EOF
}

trim() {
	local value="$1"
	value="${value#"${value%%[![:space:]]*}"}"
	value="${value%"${value##*[![:space:]]}"}"
	printf '%s' "$value"
}

shell_quote() {
	printf "'%s'" "$(printf '%s' "$1" | sed "s/'/'\\''/g")"
}

path_has_entry() {
	local path_value="$1"
	local entry="$2"
	case ":${path_value}:" in
	*":${entry}:"*) return 0 ;;
	*) return 1 ;;
	esac
}

is_sourced() {
	[ "${BASH_SOURCE[0]}" != "$0" ]
}

find_workspace_file() {
	local search_dir="$PWD"

	while :; do
		for filename in pnpm-workspace.yaml pnpm-workspace.yml; do
			if [ -f "${search_dir}/${filename}" ]; then
				printf '%s\n' "${search_dir}/${filename}"
				return 0
			fi
		done

		if [ "$search_dir" = "/" ]; then
			return 1
		fi

		search_dir="$(dirname "$search_dir")"
	done
}

extract_use_node_version() {
	local workspace_file="$1"
	local line raw value

	while IFS= read -r line || [ -n "$line" ]; do
		case "$line" in
		[[:space:]]*'#'*) continue ;;
		esac

		if [[ "$line" =~ ^[[:space:]]*useNodeVersion[[:space:]]*:[[:space:]]*(.*)$ ]]; then
			raw="${BASH_REMATCH[1]}"
			raw="${raw%%#*}"
			value="$(trim "$raw")"

			if [ -z "$value" ]; then
				return 1
			fi

			case "$value" in
			"\""*"\"")
				value="${value#\"}"
				value="${value%\"}"
				;;
			"'"*"'")
				value="${value#\'}"
				value="${value%\'}"
				;;
			esac

			printf '%s\n' "$value"
			return 0
		fi
	done <"$workspace_file"

	return 1
}

is_valid_node_version() {
	local value="$1"

	[[ "$value" =~ ^v?[0-9]+\.[0-9]+\.[0-9]+([.-][0-9A-Za-z]+([.-][0-9A-Za-z]+)*)?(\+[0-9A-Za-z.-]+)?$ ]]
}

normalize_version() {
	printf '%s\n' "${1#v}"
}

resolve_pnpm_bin() {
	local script_dir

	if [ -n "${PNPM_ACTIVATE_PNPM_BIN:-}" ]; then
		printf '%s\n' "$PNPM_ACTIVATE_PNPM_BIN"
		return 0
	fi

	script_dir="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
	if [ -x "${script_dir}/pnpm" ]; then
		printf '%s\n' "${script_dir}/pnpm"
		return 0
	fi

	if command -v pnpm >/dev/null 2>&1; then
		command -v pnpm
		return 0
	fi

	echo "pnpm-activate-env: could not find pnpm in PATH" >&2
	return 1
}

resolve_home_dir() {
	local user=""
	local home_dir=""

	if [ -n "${HOME:-}" ]; then
		printf '%s\n' "$HOME"
		return 0
	fi

	user="$(id -un 2>/dev/null || true)"
	if [ -n "$user" ]; then
		home_dir="$(eval printf '%s' "~$user" 2>/dev/null || true)"
		if [ -n "$home_dir" ] && [ "$home_dir" != "~$user" ]; then
			printf '%s\n' "$home_dir"
			return 0
		fi
	fi

	echo "pnpm-activate-env: could not determine home directory; set HOME or PNPM_HOME" >&2
	return 1
}

resolve_pnpm_home() {
	local pnpm_bin="$1"
	local global_bin=""
	local home_dir=""

	if [ -n "${PNPM_HOME:-}" ]; then
		printf '%s\n' "$PNPM_HOME"
		return 0
	fi

	global_bin="$($pnpm_bin bin -g 2>/dev/null || true)"
	global_bin="$(trim "$global_bin")"

	if [ -n "$global_bin" ] && [ "$global_bin" != "undefined" ]; then
		printf '%s\n' "$global_bin"
		return 0
	fi

	home_dir="$(resolve_home_dir)"

	case "$(uname -s)" in
	Darwin)
		printf '%s\n' "${home_dir}/Library/pnpm"
		;;
	*)
		printf '%s\n' "${home_dir}/.local/share/pnpm"
		;;
	esac
}

emit_export_script() {
	local pnpm_home="$1"
	local node_bin="$2"
	local quoted_pnpm_home
	local quoted_node_bin

	quoted_pnpm_home="$(shell_quote "$pnpm_home")"
	quoted_node_bin="$(shell_quote "$node_bin")"

	printf '__pnpm_activate_pnpm_home=%s\n' "$quoted_pnpm_home"
	printf '__pnpm_activate_node_bin=%s\n' "$quoted_node_bin"
	cat <<'EOF'
export PNPM_HOME="${__pnpm_activate_pnpm_home}"
case ":$PATH:" in
  *":${__pnpm_activate_pnpm_home}:"*) ;;
  *) export PATH="${__pnpm_activate_pnpm_home}:$PATH" ;;
esac
case ":$PATH:" in
  *":${__pnpm_activate_node_bin}:"*) ;;
  *) export PATH="${__pnpm_activate_node_bin}:$PATH" ;;
esac
unset __pnpm_activate_pnpm_home __pnpm_activate_node_bin
EOF
}

apply_path() {
	local pnpm_home="$1"
	local node_bin="$2"

	export PNPM_HOME="$pnpm_home"

	if ! path_has_entry "$PATH" "$pnpm_home"; then
		export PATH="${pnpm_home}:$PATH"
	fi

	if ! path_has_entry "$PATH" "$node_bin"; then
		export PATH="${node_bin}:$PATH"
	fi
}

main() {
	local print_export=0
	local workspace_file=""

	while [ "$#" -gt 0 ]; do
		case "$1" in
		--print-export)
			print_export=1
			;;
		--workspace-file)
			shift
			if [ "$#" -eq 0 ]; then
				echo "pnpm-activate-env: --workspace-file requires a path" >&2
				return 2
			fi
			workspace_file="$1"
			;;
		-h | --help)
			usage
			return 0
			;;
		*)
			echo "pnpm-activate-env: unknown option: $1" >&2
			usage >&2
			return 2
			;;
		esac
		shift
	done

	if [ -z "$workspace_file" ]; then
		workspace_file="$(find_workspace_file || true)"
	fi

	if [ -z "$workspace_file" ] || [ ! -f "$workspace_file" ]; then
		return 0
	fi

	local requested_version=""
	requested_version="$(extract_use_node_version "$workspace_file" || true)"

	if [ -z "$requested_version" ]; then
		return 0
	fi

	if ! is_valid_node_version "$requested_version"; then
		echo "pnpm-activate-env: ignoring unsupported useNodeVersion '${requested_version}' in ${workspace_file}" >&2
		return 0
	fi

	local version
	local pnpm_bin
	local pnpm_home
	local run_path
	local node_bin

	version="$(normalize_version "$requested_version")"
	pnpm_bin="$(resolve_pnpm_bin)"
	pnpm_home="$(resolve_pnpm_home "$pnpm_bin")"
	run_path="$PATH"

	if ! path_has_entry "$run_path" "$pnpm_home"; then
		run_path="${pnpm_home}:${run_path}"
	fi

	node_bin="${pnpm_home}/nodejs/${version}/bin"
	if [ ! -x "${node_bin}/node" ]; then
		PNPM_HOME="$pnpm_home" PATH="$run_path" "$pnpm_bin" env add --global "$version" >&2
	fi

	if [ ! -x "${node_bin}/node" ]; then
		echo "pnpm-activate-env: expected node binary at ${node_bin}/node after pnpm env add" >&2
		return 1
	fi

	if [ "$print_export" -eq 1 ]; then
		emit_export_script "$pnpm_home" "$node_bin"
		return 0
	fi

	if is_sourced; then
		apply_path "$pnpm_home" "$node_bin"
	else
		emit_export_script "$pnpm_home" "$node_bin"
	fi
}

if is_sourced; then
	main
else
	main "$@"
fi
