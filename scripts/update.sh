#!/usr/bin/env bash
set -Eeuo pipefail
BUCKET_NAME="${1:-}"
if [[ -z "${BUCKET_NAME}" ]]; then
  echo "Usage: $0 BUCKET_NAME" >&2
  exit 1
fi
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
gcloud storage rsync --recursive "${PROJECT_ROOT}/website" "gs://${BUCKET_NAME}"
echo "Website files updated: https://storage.googleapis.com/${BUCKET_NAME}/index.html"
