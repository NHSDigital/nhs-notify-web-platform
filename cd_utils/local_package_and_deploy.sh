#!/usr/bin/env bash

set -euo pipefail

tf_project="${1:-notify-web-gateway}"
environment="${2:-dev}"
action="${3:-plan}"
rebuild="${4:-no_rebuild}"
component="web-ui"
project="nhs-notify-web-gateway"


if [[ "${environment:0:3}" == "de-" ]]; then
  tfvars_environment="dynamic"
else
  tfvars_environment="${environment}"
fi

if [[ ! "${action}" == "plan" && ! "${action}" == "apply" && ! "${action}" == "state" && ! "${action}" == "show" && ! "${action}" == "import" ]]; then
  echo "ERROR: second arg should be 'plan' or 'apply' or 'state' or 'show' or 'import'" && exit 1
fi
if [[ "${rebuild}" == "rebuild" ]]; then
  pnpm package --output-logs new-only
  ./ci_utils/publish_packages.sh
fi

if [[ $? != 0 ]]; then
  echo -e "Rebuild failed. Aborting."
  exit 1
fi

# ./cd_utils/generate_target_env.sh "${project}" "${tfvars_environment}" "${project}/terraform"
pushd "infrastructure/terraform"
./bin/generate_target_env_tfvars.sh "${project}" "${environment}"
# ./bin/download_static_content.sh

if [ "${action}" == "state" ] || [ "${action}" == "import" ]; then
  echo -e "We need to provide some arguments for in a format like e.g. :::  -- rm -dry-run aws_s3_bucket.bucket_name"
  read -p "Please provide additional arguments for this action::  " arg5
fi

./bin/terrawrap.sh --project ${tf_project} --component ${component} --environment ${environment} --group target-env --action ${action} ${arg5:-} && \
rm -rf "./static_content" && \
popd

if [[ $? == 0 ]]; then
  echo -e "Local ${action} successful"
  exit 0
else
  echo -e "Rebuild failed. Aborting."
  exit 2
fi
