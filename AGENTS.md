# Repository Guidelines

## Project Structure & Module Organization

This repository is an independently maintained derivative of the AWS IAM
Terraform module. Reusable implementations live under `modules/`; matching
`wrappers/` expose collection-oriented module interfaces, and `examples/`
contain runnable usage configurations. Each module generally uses `main.tf`,
`variables.tf`, `outputs.tf`, and `versions.tf`. User documentation is in
`README.md`, module-level READMEs, and `docs/`. Read `UPSTREAM.md` before
changing imported content or synchronizing a new upstream release.

## Build, Test, and Development Commands

- `terraform fmt -check -recursive` checks formatting across all Terraform
  roots; run `terraform fmt -recursive` to apply formatting.
- `pre-commit run --all-files` runs formatting, generated documentation,
  TFLint rules, validation, and whitespace checks.
- `terraform init -backend=false && terraform validate` initializes and
  validates the current module, wrapper, or example without configuring state.

Run initialization and validation from every affected Terraform root. The
repository currently has no `*.tftest.hcl` suite, so do not cite
`terraform test` as evidence unless tests are added with the change.

## Coding Style & Naming Conventions

Follow `.editorconfig`: UTF-8, LF endings, final newlines, two-space indentation,
and no trailing whitespace (Markdown is exempt). Let `terraform fmt` determine
HCL layout. Use lowercase kebab-case directory names such as `iam-oidc-provider`
and descriptive snake_case Terraform identifiers. Preserve the established
module file layout and document variables and outputs so configured TFLint
rules pass. Do not manually edit content between `BEGIN_TF_DOCS` and
`END_TF_DOCS`; update the Terraform source and regenerate those sections through
pre-commit. Wrapper READMEs contain derivative-pinned sources and must not be
overwritten with upstream wrapper-generator output.

## Testing and Security Guidelines

Prefer validation that does not contact AWS or mutate infrastructure. Never
commit state, saved plans, `.terraform/`, credentials, or provider debug logs.
Review IAM policy and trust-policy changes for unnecessary wildcards, broadened
principals, and privilege expansion. Do not run `terraform apply`,
`terraform destroy`, import or state commands, or publish releases without
explicit authorization. Do not use `terraform init -upgrade` or manually edit
`.terraform.lock.hcl` unless dependency upgrades are part of the request.

## Commit & Pull Request Guidelines

History uses Conventional Commit prefixes such as `feat:`, `fix:`, `docs:`,
`ci:`, and `chore:`. Keep commits focused. PR titles must use one of those types
and begin their subject with a capital letter, for example
`fix: Preserve IAM policy conditions`. PRs should explain behavior and security
impact, link relevant issues, list affected roots, and report the exact checks
run. For upstream updates, follow `UPSTREAM.md`; never merge an upstream branch
directly.
