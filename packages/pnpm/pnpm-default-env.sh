# Shared runtime defaults for the standalone pnpm package.
# This file is sourced by the pnpm wrapper and by the Nix setup hook.

pnpm_default_home() {
	if [ -n "${XDG_DATA_HOME:-}" ]; then
		printf '%s\n' "${XDG_DATA_HOME}/pnpm"
		return 0
	fi

	if [ -z "${HOME:-}" ] || [ "${HOME}" = /homeless-shelter ]; then
		return 1
	fi

	case "$(uname -s)" in
	Darwin)
		printf '%s\n' "${HOME}/Library/pnpm"
		;;
	*)
		printf '%s\n' "${HOME}/.local/share/pnpm"
		;;
	esac
}

pnpm_global_bin_dir() {
	if [ -z "${PNPM_HOME:-}" ]; then
		return 1
	fi

	if [ "@PNPM_USE_RUNTIME_COMMAND@" = "1" ]; then
		printf '%s\n' "${PNPM_HOME}/bin"
	else
		printf '%s\n' "${PNPM_HOME}"
	fi
}

pnpm_set_mutable_state_defaults() {
	if [ -z "${PNPM_HOME:-}" ]; then
		PNPM_HOME="$(pnpm_default_home || true)"
		if [ -n "${PNPM_HOME:-}" ]; then
			export PNPM_HOME
		fi
	fi

	if [ -n "${PNPM_HOME:-}" ]; then
		mkdir -p "${PNPM_HOME}" "$(pnpm_global_bin_dir)" 2>/dev/null || true
	fi
}

pnpm_prepend_global_bin() {
	local pnpm_global_bin

	pnpm_global_bin="$(pnpm_global_bin_dir || true)"
	if [ -z "${pnpm_global_bin:-}" ]; then
		return 0
	fi

	case ":${PATH:-}:" in
	*":${pnpm_global_bin}:"*) ;;
	*) export PATH="${pnpm_global_bin}:${PATH:-}" ;;
	esac
}

pnpm_set_mutable_state_defaults
