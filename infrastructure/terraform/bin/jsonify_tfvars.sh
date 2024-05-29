#!/usr/bin/env bash

set -euo pipefail

input_file="${1:-env_eu-west-2_uat2.tfvars}"
output="${2:-json}"

json_input="{"$( \
  cat ${input_file} | \
    sed -Eze 's/ = /:/g' \
    -e 's/,//' \
    -e 's/\n$//' \
    -e 's/\n/,/g' \
    -e 's/\s*#[^,]*,/,/g' \
    -e 's/,+/,/g' \
    -e 's/\[,/\[/g' \
    -e 's/\{,/\{/g' \
    -e 's/,\s*\]/\]/g' \
    -e 's/,\s*\}/\}/g' \
    -e 's/\-/_/g' \
)"}"

if [[ ${output} == "json" ]]; then
  jq --null-input -c "${json_input}"
else
  echo "${json_input}"
fi
