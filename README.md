# Cloud-Based Static Website Hosting & Management using Google Cloud Storage

A beginner-friendly portfolio project that publishes a responsive static website to Google Cloud Storage using the Google Cloud CLI.

## Project overview

This project demonstrates how to:
- Create a Google Cloud Storage bucket.
- Enable uniform bucket-level access.
- Configure public access for website objects.
- Upload HTML, CSS, JavaScript, and image assets.
- Configure `index.html` and `404.html` website suffixes.
- Verify the published site and update it after code changes.
- Remove project resources when finished.

## Architecture

```text
Developer
   |
   | Git push / local source code
   v
GitHub repository
   |
   | gcloud storage rsync
   v
Google Cloud Storage bucket
   |-- index.html
   |-- 404.html
   |-- assets/style.css
   |-- assets/script.js
   |
   v
Public object URL (HTTPS)
   |
   v
Visitor's browser
```

## Important hosting and security notes

- Cloud Storage static website hosting supports client-side HTML, CSS, and JavaScript. It does not run server-side code such as PHP or Python.
- This project makes the bucket's objects publicly readable. **Never upload passwords, API keys, private documents, personal data, or other confidential files.**
- Public access prevention must be disabled for a public bucket. An organization policy can prevent this; if so, use a permitted test project or ask its administrator rather than trying to bypass the policy.
- The project enables uniform bucket-level access and grants `allUsers` the `roles/storage.objectViewer` role at bucket level.
- Cloud Storage does not provide end-to-end HTTPS for a custom domain by itself. The project prints an HTTPS object URL for `index.html` so you can test the page without buying a domain. To use a domain with website index/error routing, configure the website endpoint and DNS. For a custom domain over HTTPS, add an external Application Load Balancer and certificate; these can incur additional charges.
- Google Cloud usage can incur charges. Review pricing and billing before deployment. Delete the bucket when finished if you no longer need it.

## Prerequisites

1. Google Cloud project with billing enabled.
2. Permission to create and manage Storage buckets and IAM policies (for example, Storage Admin).
3. Google Cloud CLI installed, or use Google Cloud Shell.
4. Git and a GitHub account (optional, for source control).

## Repository structure

```text
gcs-static-website-hosting/
├── README.md
├── .gitignore
├── LICENSE
├── website/
│   ├── index.html
│   ├── 404.html
│   └── assets/
│       ├── style.css
│       └── script.js
└── scripts/
    ├── deploy.sh
    ├── update.sh
    ├── status.sh
    └── cleanup.sh
```

## 1. Set your Google Cloud project

Open Google Cloud Console and activate Cloud Shell, or use a terminal where `gcloud` is installed.

```bash
gcloud auth list
gcloud projects list
gcloud config set project YOUR_PROJECT_ID
gcloud config get-value project
```

Replace `YOUR_PROJECT_ID` with your own project ID.

## 2. Clone your GitHub repository

After creating an empty GitHub repository and pushing this project, clone it:

```bash
git clone https://github.com/YOUR_GITHUB_USERNAME/gcs-static-website-hosting.git
cd gcs-static-website-hosting
chmod +x scripts/*.sh
```

Alternatively, upload this project folder to Cloud Shell.

## 3. Choose a globally unique bucket name

Cloud Storage bucket names are globally unique. Use lowercase letters, numbers, hyphens, and a name that is 3–63 characters long. For example:

```bash
export BUCKET_NAME="kunal-gcs-static-site-2026"
export LOCATION="asia-south1"
```

Change the example to a unique name. Do not use your actual name if you prefer not to make it public.

## 4. Deploy the website

```bash
./scripts/deploy.sh "$BUCKET_NAME" "$LOCATION"
```

The script:
1. Checks your active Google Cloud project.
2. Creates the bucket if it does not exist.
3. Enables uniform bucket-level access.
4. Disables public access prevention at the bucket level (if organization policy permits).
5. Grants public object-viewer access.
6. Configures `index.html` and `404.html` as website suffixes.
7. Uploads website files.

The bucket is public after this step. Only use it for files intended for public viewing.

## 5. Open and test the website

```bash
./scripts/status.sh "$BUCKET_NAME"
```

Open the HTTPS object URL printed by the script. It will look like:

```text
https://storage.googleapis.com/YOUR_BUCKET_NAME/index.html
```

This URL serves the HTML object over HTTPS. It is not the custom-domain website endpoint and does not itself demonstrate website index/error routing. The bucket website configuration is saved for use with a website endpoint and domain/DNS setup.

## 6. Update your website

Edit the files in `website/`, then run:

```bash
./scripts/update.sh "$BUCKET_NAME"
```

Refresh the public URL to see your changes. Browser caching can delay visible updates.

## 7. Verify bucket configuration

```bash
gcloud storage buckets describe "gs://$BUCKET_NAME"
gcloud storage buckets get-iam-policy "gs://$BUCKET_NAME"
gcloud storage ls "gs://$BUCKET_NAME"
```

You can also inspect the bucket in the Google Cloud Console: Cloud Storage → Buckets → your bucket → Permissions / Configuration.

## 8. Cleanup

When you no longer need the demo:

```bash
./scripts/cleanup.sh "$BUCKET_NAME"
```

The script asks you to type `DELETE` before removing the bucket and its contents. This deletion is permanent after applicable recovery/soft-delete settings. Confirm the bucket name carefully.

## Troubleshooting

| Error | What to check |
|---|---|
| Bucket name already exists | Choose another globally unique bucket name |
| `PERMISSION_DENIED` | Check your IAM roles and selected project |
| Public access prevention enforced | A project/organization policy may block public access; use an allowed project or administrator-approved exception |
| Website returns 403 | Confirm `allUsers` has `roles/storage.objectViewer` and public access is permitted |
| `gcloud` not found | Use Cloud Shell or install Google Cloud CLI |
| Changes do not appear | Run update script and hard-refresh the browser |
| Billing/API issue | Check billing status, project selection, and Cloud Storage service status |

## Resume-ready project description

**Cloud-Based Static Website Hosting using Google Cloud Storage | GCP, Cloud Storage, IAM, HTML, CSS, JavaScript, gcloud CLI**

- Developed a responsive static website using HTML, CSS, and JavaScript and published its assets to Google Cloud Storage.
- Created and configured a Cloud Storage bucket using the Google Cloud CLI, including website index and error page settings.
- Implemented bucket-level IAM permissions and uniform bucket-level access for controlled public object delivery.
- Automated website deployment and updates using Bash scripts and `gcloud storage` commands.

Only include claims that you personally deployed and verified.

## GitHub upload

Create an empty public repository named `gcs-static-website-hosting`, then run these commands from this folder:

```bash
git init
git add .
git commit -m "Initial commit: GCS static website hosting"
git branch -M main
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/gcs-static-website-hosting.git
git push -u origin main
```

Replace `YOUR_GITHUB_USERNAME`. Do not commit cloud credentials, service-account keys, private files, or `.env` files.
