#!/usr/bin/env bash
set -Eeuo pipefail

BUCKET_NAME="${1:-}"
LOCATION="${2:-asia-south1}"
PROJECT_ID="$(gcloud config get-value project 2>/dev/null)"

if [[ -z "${BUCKET_NAME}" ]]; then
  echo "Usage: $0 UNIQUE_BUCKET_NAME [LOCATION]" >&2
  echo "Example: $0 my-unique-static-site-2026 asia-south1" >&2
  exit 1
fi
if [[ -z "${PROJECT_ID}" || "${PROJECT_ID}" == "(unset)" ]]; then
  echo "Set a project first: gcloud config set project YOUR_PROJECT_ID" >&2
  exit 1
fi
if [[ ! "${BUCKET_NAME}" =~ ^[a-z0-9][a-z0-9._-]{1,61}[a-z0-9]$ ]]; then
  echo "Bucket name must be 3-63 characters and use lowercase letters, numbers, hyphens, underscores, or dots." >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
WEBSITE_DIR="${PROJECT_ROOT}/website"

echo "Project: ${PROJECT_ID}"
echo "Bucket: gs://${BUCKET_NAME}"
echo "Location: ${LOCATION}"
echo "WARNING: This deployment makes website objects publicly readable."

if gcloud storage buckets describe "gs://${BUCKET_NAME}" --project="${PROJECT_ID}" >/dev/null 2>&1; then
  echo "Bucket already exists; using it."
else
  gcloud storage buckets create "gs://${BUCKET_NAME}" \
    --project="${PROJECT_ID}" \
    --location="${LOCATION}" \
    --uniform-bucket-level-access \
    --no-public-access-prevention
fi

# Public access is required for this public static-site demo.
# This can fail if a project or organization policy enforces public access prevention.
gcloud storage buckets update "gs://${BUCKET_NAME}" \
  --project="${PROJECT_ID}" \
  --uniform-bucket-level-access \
  --no-public-access-prevention

gcloud storage buckets add-iam-policy-binding "gs://${BUCKET_NAME}" \
  --project="${PROJECT_ID}" \
  --member=allUsers \
  --role=roles/storage.objectViewer

gcloud storage buckets update "gs://${BUCKET_NAME}" \
  --project="${PROJECT_ID}" \
  --web-main-page-suffix=index.html \
  --web-error-page=404.html

gcloud storage rsync --recursive "${WEBSITE_DIR}" "gs://${BUCKET_NAME}"

echo
echo "Upload complete."
echo "HTTPS page URL: https://storage.googleapis.com/${BUCKET_NAME}/index.html"
echo "Bucket website configuration: main page index.html; error page 404.html"
echo "Check the result with: ./scripts/status.sh ${BUCKET_NAME}"
