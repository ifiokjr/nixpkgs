# CLAUDE.md

## Commit conventions

Use [Conventional Commits](https://www.conventionalcommits.org/) for all commit messages and PR titles.

Format: `<type>(<scope>): <description>`

Types:

- `feat` — new package or feature
- `fix` — bug fix
- `chore` — maintenance, CI, scripts, dependency updates
- `docs` — documentation only
- `refactor` — code change that neither fixes a bug nor adds a feature

Scope is optional. When used, it should be the package name (e.g., `feat(pnpm-standalone): add Linux support`).

## Repository structure

- `packages/<name>/package.nix` — individual package definitions
- `flake.nix` — flake with overlay and per-system outputs
- `.github/workflows/ci.yml` — CI with change detection and matrix builds
- `scripts/update` — nushell script to update all packages to latest versions

## Formatting

Always run `dprint fmt` before pushing to ensure all files are properly formatted. If `dprint fmt` makes changes, commit them before pushing.

## Nushell

The `scripts/update` script is written in nushell. When writing `$"..."` interpolated strings, remember that `(...)` inside them is always treated as interpolation. Use `\(` and `\)` to produce literal parentheses.
