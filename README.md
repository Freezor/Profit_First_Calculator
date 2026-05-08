# Profit First Calculator

A single-page Profit First calculator for freelancers. The app is plain HTML, CSS, and JavaScript in `index.html`, so it can be published directly with GitHub Pages.

## GitHub Pages deployment

This repository includes a GitHub Actions workflow at `.github/workflows/pages.yml` that packages `index.html` and `.nojekyll` into a static GitHub Pages artifact and deploys it whenever changes are pushed to `main`, `master`, or `work`. It can also be run manually from the **Actions** tab with `workflow_dispatch`.

After the workflow has run successfully, the site will be available at:

```text
https://<your-github-username-or-org>.github.io/Profit_First_Calculator/
```

If Pages is not enabled yet, open **Settings → Pages** in GitHub and set **Build and deployment → Source** to **GitHub Actions**.

## OpenClaw integration UX

Guidance for the Flutter authentication and first-run onboarding experience for self-hosted OpenClaw instances is available in [`docs/openclaw_auth_onboarding_ux.md`](docs/openclaw_auth_onboarding_ux.md).

## Local preview

Because the app is static, you can preview it locally with any static file server. For example:

```bash
python3 -m http.server 8000
```

Then open <http://localhost:8000/>.
