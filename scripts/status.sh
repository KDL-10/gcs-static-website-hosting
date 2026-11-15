#!/usr/bin/env bash
set -Eeuo pipefail
BUCKET_NAME="${1:-}"
if [[ -z "${BUCKET_NAME}" ]]; then
  echo "Usage: $0 BUCKET_NAME" >&2
  exit 1
fi
echo "Bucket details:"
gcloud storage buckets describe "gs://${BUCKET_NAME}"
echo
echo "Objects:"
gcloud storage ls --recursive "gs://${BUCKET_NAME}"
echo
echo "Open this page:"
echo "https://storage.googleapis.com/${BUCKET_NAME}/index.html"
echo
echo "Bucket IAM policy:"
gcloud storage buckets get-iam-policy "gs://${BUCKET_NAME}"
