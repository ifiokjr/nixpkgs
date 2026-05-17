#!/usr/bin/env bash
set -euo pipefail

PNPM_ACTIVATE_USE_RUNTIME="@PNPM_ACTIVATE_USE_RUNTIME@"

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
	*":${entry}:") return 0 ;;
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

find_package_json() {
	local search_dir="$PWD"

	while :; do
		if [ -f "${search_dir}/package.json" ]; then
			printf '%s\n' "${search_dir}/package.json"
			return 0
		fi

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

extract_dev_engines_node_version() {
	local package_json="$1"
	local compact
	local runtime
	local version

	compact="$(tr -d '\n\r' <"$package_json")"

	case "$compact" in
	*'"devEngines"'*'"runtime"'*) ;;
	*) return 1 ;;
	esac

	runtime="$(printf '%s\n' "$compact" | sed -n 's/.*"runtime"[[:space:]]*:[[:space:]]*\(\[[^]]*\]\|{[^}]*}\).*/\1/p')"
	if [ -z "$runtime" ]; then
		return 1
	fi

	version="$(printf '%s\n' "$runtime" | sed -n 's/.*"name"[[:space:]]*:[[:space:]]*"node".*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"
	if [ -z "$version" ]; then
		version="$(printf '%s\n' "$runtime" | sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*"name"[[:space:]]*:[[:space:]]*"node".*/\1/p')"
	fi

	if [ -n "$version" ]; then
		printf '%s\n' "$version"
		return 0
	fi

	return 1
}

is_valid_node_version() {
	local value="$1"

	[[ "$value" =~ ^v?[0-9]+\.[0-9]+\.[0-9]+([.-][0-9A-Za-z]+([.-][0-9A-Za-z]+)*)?(\+[0-9A-Za-z.-]+)?$ ]]
}

is_valid_runtime_version() {
	local value="$1"

	case "$value" in
	"" | *[!A-Za-z0-9._+/'<''>''='~'^'*-]*) return 1 ;;
	*) return 0 ;;
	esac
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
		case "$global_bin" in
		/homeless-shelter | /homeless-shelter/*) ;;
		*)
			printf '%s\n' "$global_bin"
			return 0
			;;
		esac
	fi

	if [ -n "${XDG_DATA_HOME:-}" ]; then
		printf '%s\n' "${XDG_DATA_HOME}/pnpm"
		return 0
	fi

	if [ "${HOME:-}" = "/homeless-shelter" ]; then
		printf '%s\n' "${PWD}/.pnpm-home"
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
	local global_bin="$pnpm_home"
	local quoted_pnpm_home
	local quoted_global_bin
	local quoted_node_bin

	if [ "$PNPM_ACTIVATE_USE_RUNTIME" = "1" ]; then
		global_bin="${pnpm_home}/bin"
	fi

	quoted_pnpm_home="$(shell_quote "$pnpm_home")"
	quoted_global_bin="$(shell_quote "$global_bin")"
	quoted_node_bin="$(shell_quote "$node_bin")"

	printf '__pnpm_activate_pnpm_home=%s\n' "$quoted_pnpm_home"
	printf '__pnpm_activate_global_bin=%s\n' "$quoted_global_bin"
	printf '__pnpm_activate_node_bin=%s\n' "$quoted_node_bin"
	cat <<'EOF'
export PNPM_HOME="${__pnpm_activate_pnpm_home}"
__pnpm_activate_old_path="${PATH:-}"
PATH=""
IFS=:
for __pnpm_activate_path_entry in ${__pnpm_activate_old_path}; do
  if [ "${__pnpm_activate_path_entry}" != "${__pnpm_activate_global_bin}" ] && [ "${__pnpm_activate_path_entry}" != "${__pnpm_activate_node_bin}" ]; then
    if [ -z "${PATH}" ]; then
      PATH="${__pnpm_activate_path_entry}"
    else
      PATH="${PATH}:${__pnpm_activate_path_entry}"
    fi
  fi
done
unset IFS
if [ "${__pnpm_activate_global_bin}" = "${__pnpm_activate_node_bin}" ]; then
  export PATH="${__pnpm_activate_global_bin}:${PATH}"
else
  export PATH="${__pnpm_activate_global_bin}:${__pnpm_activate_node_bin}:${PATH}"
fi
unset __pnpm_activate_pnpm_home __pnpm_activate_global_bin __pnpm_activate_node_bin __pnpm_activate_old_path __pnpm_activate_path_entry
EOF
}

apply_path() {
	local pnpm_home="$1"
	local node_bin="$2"
	local global_bin="$pnpm_home"
	local old_path="$PATH"
	local new_path=""
	local entry

	if [ "$PNPM_ACTIVATE_USE_RUNTIME" = "1" ]; then
		global_bin="${pnpm_home}/bin"
	fi

	export PNPM_HOME="$pnpm_home"

	IFS=:
	for entry in $old_path; do
		if [ "$entry" != "$global_bin" ] && [ "$entry" != "$node_bin" ]; then
			if [ -z "$new_path" ]; then
				new_path="$entry"
			else
				new_path="${new_path}:$entry"
			fi
		fi
	done
	unset IFS

	if [ "$global_bin" = "$node_bin" ]; then
		export PATH="${global_bin}:${new_path}"
	else
		export PATH="${global_bin}:${node_bin}:${new_path}"
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

	local requested_version=""
	local requested_source=""

	if [ -n "$workspace_file" ] && [ -f "$workspace_file" ]; then
		requested_version="$(extract_use_node_version "$workspace_file" || true)"
		requested_source="$workspace_file"
	fi

	if [ -z "$requested_version" ] && [ "$PNPM_ACTIVATE_USE_RUNTIME" = "1" ]; then
		local package_json=""
		package_json="$(find_package_json || true)"
		if [ -n "$package_json" ] && [ -f "$package_json" ]; then
			requested_version="$(extract_dev_engines_node_version "$package_json" || true)"
			requested_source="$package_json"
		fi
	fi

	if [ -z "$requested_version" ]; then
		return 0
	fi

	if [ "$PNPM_ACTIVATE_USE_RUNTIME" = "1" ]; then
		if ! is_valid_runtime_version "$requested_version"; then
			echo "pnpm-activate-env: ignoring unsupported Node.js runtime '${requested_version}' in ${requested_source}" >&2
			return 0
		fi
	elif ! is_valid_node_version "$requested_version"; then
		echo "pnpm-activate-env: ignoring unsupported useNodeVersion '${requested_version}' in ${requested_source}" >&2
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

	if [ "$PNPM_ACTIVATE_USE_RUNTIME" = "1" ]; then
		node_bin="${pnpm_home}/bin"
		if [ ! -x "${node_bin}/node" ]; then
			PNPM_HOME="$pnpm_home" PATH="${pnpm_home}/bin:$run_path" "$pnpm_bin" runtime set node "$version" --global >&2
		fi
	else
		node_bin="${pnpm_home}/nodejs/${version}/bin"
		if [ ! -x "${node_bin}/node" ]; then
			PNPM_HOME="$pnpm_home" PATH="$run_path" "$pnpm_bin" env add --global "$version" >&2
		fi
	fi

	if [ ! -x "${node_bin}/node" ]; then
		echo "pnpm-activate-env: expected node binary at ${node_bin}/node after installing Node.js ${version}" >&2
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
