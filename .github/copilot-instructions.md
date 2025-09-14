# Repository Guidelines

This repo hosts Kubernetes infrastructure as code. The tree is intentionally minimal; add components as they are introduced and keep changes small, reviewable, and automated.

## Project Structure & Module Organization
- `clusters/<env>/`: K8s entrypoints per environment (e.g., `prod/`, `staging/`).
- `apps/<name>/base/` and `apps/<name>/overlays/<env>/`: Kustomize pattern for app manifests.
- `charts/`: Helm charts maintained here (optional).
- `terraform/` or `infra/`: Cloud primitives (VPC, clusters, DNS).
- `scripts/`: Developer utilities (idempotent, POSIX shell).
- `.github/`: CI workflows, PR templates.

## Build, Test, and Development Commands
- Validate YAML: `yamllint .` — fast syntax/style checks.
- Validate manifests: `kubeconform -strict -summary -kubernetes-version 1.29 ./`.
- Kustomize build: `kustomize build apps/<name>/overlays/<env>` — render manifests.
- Helm chart lint: `helm lint charts/<chart>`; template: `helm template <release> charts/<chart>`.
- Diff against cluster: `kubectl diff -k apps/<name>/overlays/<env>`.
- Apply: `kubectl apply -k apps/<name>/overlays/<env>` (never to `prod` without review).

## Coding Style & Naming Conventions
- YAML: 2‑space indent; keys kebab‑case; lists over inline objects.
- Resource names: `app-component-scope` (e.g., `payments-worker-prod`).
- Directories: lowercase, hyphenated; environments `dev`, `staging`, `prod`.
- Keep manifests small; prefer one resource per file.
- Tools: `pre-commit` with `yamllint`, `kubeconform`, `helm lint` recommended.

## Testing Guidelines
- Render tests pass: `kustomize build`/`helm template` must succeed.
- Schema valid: `kubeconform` clean and `helm lint` with 0 warnings.
- For logic (Terraform/modules), add unit tests via `terratest` or module `validate` steps.
- Name tests and overlays to mirror the path under `apps/` for easy discovery.

## Commit & Pull Request Guidelines
- Use Conventional Commits (e.g., `feat:`, `fix:`, `chore:`); scope optional (`feat(apps/payments): ...`).
- One logical change per PR; include context, risk, and rollback steps.
- Attach `kubectl diff`/`helm diff` output in the PR description for affected envs.
- Link issues; include screenshots/logs for UI‑facing changes (dashboards, ingress).

## Security & Configuration Tips
- Never commit secrets; use SOPS or External Secrets Operator.
- Enforce least privilege RBAC; pin container images by digest; set requests/limits.
- Protect `prod` with required reviews and CI gates.
