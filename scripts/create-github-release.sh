#!/usr/bin/env bash
set -euo pipefail

# Creates or updates a GitHub release using version info from this repo.
# Usage:
#   ./scripts/create-github-release.sh <asset1> [asset2 ...]

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$repo_root"

if ! command -v gh >/dev/null 2>&1; then
  echo "Error: gh CLI is required." >&2
  exit 1
fi

version_name="${INFIPD_VERSION_NAME:-}"
if [[ -z "$version_name" ]]; then
  version_name="$(sed -n 's/^infipd\.versionName=//p' gradle.properties | head -n1)"
fi

if [[ -z "$version_name" ]]; then
  echo "Error: Could not resolve version name (INFIPD_VERSION_NAME or gradle.properties)." >&2
  exit 1
fi

semver="$(echo "$version_name" | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -n1 || true)"
if [[ -z "$semver" ]]; then
  echo "Error: Could not extract semantic version (MAJOR.MINOR.PATCH) from version name: $version_name" >&2
  exit 1
fi

tag="v${semver}"

if [[ $# -lt 1 ]]; then
  echo "Error: Provide at least one release asset path." >&2
  echo "Usage: ./scripts/create-github-release.sh <asset1> [asset2 ...]" >&2
  exit 1
fi

if gh release view "$tag" >/dev/null 2>&1; then
  gh release edit "$tag" --title "$version_name"
  gh release upload "$tag" "$@" --clobber
  echo "Updated release $tag with title: $version_name"
else
  gh release create "$tag" "$@" --title "$version_name" --notes "Release $version_name"
  echo "Created release $tag with title: $version_name"
fi
