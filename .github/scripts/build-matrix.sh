#!/usr/bin/env bash
# Turn frankenphp/versions.json into a build matrix for GitHub Actions.
#
# Input:  a JSON array of base tags, for example "1.13.5-php8.4.27-trixie@sha256:...".
# Output: a JSON array with one object per PHP version:
#   { "id": "php8.4", "base_tag": "...", "frankenphp": "1.13.5", "php": "8.4.27", "tags": "a,b,c" }
#
# The tags mirror the upstream scheme <frankenphp-version>[-php<php-version>] from major to patch.
# The newest PHP version also gets the tags without a PHP suffix, plus "latest".
set -euo pipefail

versions_file="${1:-frankenphp/versions.json}"
mapfile -t base_tags < <(jq -r '.[]' "$versions_file")

newest_php="$(printf '%s\n' "${base_tags[@]}" | sed -E 's/^.*-php([0-9.]+)-.*$/\1/' | sort -V | tail -n 1)"

entries=()
for base_tag in "${base_tags[@]}"; do
  if [[ ! "$base_tag" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)-php([0-9]+)\.([0-9]+)\.([0-9]+)- ]]; then
    echo "Unexpected base tag in ${versions_file}: ${base_tag}" >&2
    exit 1
  fi
  frankenphp_major="${BASH_REMATCH[1]}"
  frankenphp_minor="${frankenphp_major}.${BASH_REMATCH[2]}"
  frankenphp="${frankenphp_minor}.${BASH_REMATCH[3]}"
  php_minor="${BASH_REMATCH[4]}.${BASH_REMATCH[5]}"
  php="${php_minor}.${BASH_REMATCH[6]}"

  tags=()
  if [ "$php" = "$newest_php" ]; then
    tags+=(latest "$frankenphp_major" "$frankenphp_minor" "$frankenphp")
  fi
  for frankenphp_part in "$frankenphp_major" "$frankenphp_minor" "$frankenphp"; do
    tags+=("${frankenphp_part}-php${php_minor}" "${frankenphp_part}-php${php}")
  done
  tags+=("php${php_minor}" "php${php}")

  entries+=("$(jq -n -c \
    --arg id "php${php_minor}" \
    --arg base_tag "$base_tag" \
    --arg frankenphp "$frankenphp" \
    --arg php "$php" \
    --arg tags "$(IFS=,; echo "${tags[*]}")" \
    '{id: $id, base_tag: $base_tag, frankenphp: $frankenphp, php: $php, tags: $tags}')")
done

printf '%s\n' "${entries[@]}" | jq -c -s .
