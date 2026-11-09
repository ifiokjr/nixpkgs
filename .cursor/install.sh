#!/usr/bin/env bash
# Bootstrap a Linux cloud agent for this flake.
#
# Single-user Nix: the base image has no systemd, so the multi-user daemon
# is not installed. The Nix sandbox does work here and stays on.
# Idempotent — a second run only refreshes symlinks, config, and store paths.
set -euo pipefail

if [ ! -x "${HOME}/.nix-profile/bin/nix" ]; then
	curl --proto '=https' --tlsv1.2 -fsSL https://nixos.org/nix/install | sh -s -- --no-daemon --yes
fi

# Login shells pick Nix up from ~/.profile. Agent shells are not login
# shells, so also expose the tools on the default PATH.
if [ -x "${HOME}/.nix-profile/bin/nix" ]; then
	sudo ln -sfn "${HOME}/.nix-profile/bin/nix" /usr/local/bin/nix
	for cmd in nix-build nix-channel nix-env nix-instantiate nix-prefetch-url nix-shell nix-store; do
		if [ -e "${HOME}/.nix-profile/bin/${cmd}" ]; then
			sudo ln -sfn "${HOME}/.nix-profile/bin/${cmd}" "/usr/local/bin/${cmd}"
		fi
	done
fi
hash -r

mkdir -p "${HOME}/.config/nix"
cat >"${HOME}/.config/nix/nix.conf" <<'EOF'
experimental-features = nix-command flakes
EOF

# The official installer appends this itself. Keep the guard so a partial
# install still yields NIX_PROFILES and NIX_SSL_CERT_FILE in login shells.
if [ -f "${HOME}/.profile" ] && ! grep -q 'nix-profile/etc/profile.d/nix.sh' "${HOME}/.profile"; then
	printf '\nif [ -e %s/.nix-profile/etc/profile.d/nix.sh ]; then . %s/.nix-profile/etc/profile.d/nix.sh; fi\n' "${HOME}" "${HOME}" >>"${HOME}/.profile"
fi

if [ -d .git ]; then
	git config core.hooksPath .githooks
fi

# Pinned nixpkgs, then the package list CI builds on Linux.
nix flake metadata --no-write-lock-file >/dev/null
nix eval --json .#ciPackages.x86_64-linux >/dev/null

# Tools the lint and update-script jobs shell out to. --no-link only warms
# the store; later revisions do not have to update a profile root.
nix build --no-link \
	nixpkgs#dprint \
	nixpkgs#nixfmt-rfc-style \
	nixpkgs#shfmt \
	nixpkgs#nushell \
	nixpkgs#jq \
	nixpkgs#actionlint \
	nixpkgs#zizmor
