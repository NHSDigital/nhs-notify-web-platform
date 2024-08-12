#!/bin/bash

set -euo pipefail

# TFSec command wrapper. It will run the command natively if TFsec is
# installed, otherwise it will run it in a Docker container.
#
# Usage:
#   $ ./scripts/terraform/tfsec.sh
#
# ==============================================================================

function main() {
  # shellcheck disable=SC2086
  tfsec \
    --concise-output \
    --force-all-dirs \
    --exclude-downloaded-modules \
    --config-file scripts/config/tfsec.yml \
    --format text
}

main "$@"

exit 0
