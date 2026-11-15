#!/usr/bin/env bash
set -Eeuo pipefail
BUCKET_NAME="${1:-}"
if [[ -z "${BUCKET_NAME}" ]]; then
  echo "Usage: $0 BUCKET_NAME" >&2
  exit 1
fi
echo "WARNING: This permanently removes all objects in gs://${BUCKET_NAME} and deletes the bucket."
read -r -p "Type DELETE to continue: " CONFIRM
if [[ "${CONFIRM}" != "DELETE" ]]; then
  echo "Cancelled."
  exit 0
fi
gcloud storage rm --recursive "gs://${BUCKET_NAME}"
echo "Bucket cleanup command completed."
