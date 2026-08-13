# Repository Guidelines

## Project Structure & Module Organization

This repository is an independently maintained derivative of the AWS IAM
Terraform module. Reusable implementations live in `modules/`; corresponding
`wrappers/` provide collection-oriented interfaces, and `examples/` contain
runnable usage configurations. Each root generally follows the standard
`main.tf`, `variables.tf`, `outputs.tf`, and `versions.tf` layout. Documentation
lives in `README.md`, module-level READMEs, and `docs/`. Read `UPSTREAM.md`
before importing or synchronizing upstream changes.

## Build, Test, and Development Commands

- `terraform fmt -check -recursive` checks HCL formatting; use
  `terraform fmt -recursive` to apply fixes.
- `pre-commit run --all-files` runs formatting, Terraform docs, TFLint,
  validation, and whitespace checks.
- `terraform init -backend=false && terraform validate` initializes and
  validates the current module, wrapper, or example without configuring state.

Run initialization and validation from every affected Terraform root. There is
currently no `*.tftest.hcl` suite, so do not report `terraform test` as evidence
unless tests are added with the change.

## Coding Style & Naming Conventions

Follow `.editorconfig`: UTF-8, LF endings, final newlines, two-space indentation,
and no trailing whitespace (Markdown is exempt). Let `terraform fmt` determine
HCL layout. Use lowercase kebab-case directory names, such as
`iam-oidc-provider`, and descriptive snake_case Terraform identifiers. Preserve
the established module file layout and document variables and outputs so TFLint
passes. Do not manually edit README content between `BEGIN_TF_DOCS` and
`END_TF_DOCS`; update Terraform source and regenerate docs through pre-commit.

## Testing & Security Guidelines

Prefer checks that do not contact AWS or mutate infrastructure. Never commit
state, saved plans, `.terraform/`, credentials, or provider debug logs. Review
IAM and trust-policy changes for broadened principals, wildcard permissions,
and privilege expansion. Do not run `terraform apply`, `terraform destroy`,
import or state commands, or publish releases without explicit authorization.
Avoid `terraform init -upgrade` and manual lockfile edits unless dependency
upgrades are explicitly in scope.

## Commit & Pull Request Guidelines

History uses Conventional Commit prefixes such as `feat:`, `fix:`, `docs:`,
`ci:`, and `chore:`. PR titles must use one of these types and start the subject
with a capital letter, for example `fix: Preserve IAM policy conditions`. Keep
commits focused. PRs should explain behavior and security impact, link relevant
issues, identify affected Terraform roots, and list exact checks run. Follow
`UPSTREAM.md` for upstream updates; never merge an upstream branch directly.

## Terraform Repository Context

This is a reusable module library, not an environment or live-infrastructure
repository. It defines no shared backend, workspace model, deployment
environment, or repository-managed secret store. Do not invent those concepts
or add environment-specific state configuration while making module changes.

- Supported Terraform: `>= 1.5.7`.
- Primary provider: `hashicorp/aws >= 6.28`, used by the IAM modules.
- Additional provider: `hashicorp/tls >= 3.0`, used by the OIDC provider module.
- CI/CD: GitHub Actions with repository pre-commit and Terraform validation
  workflows. Release automation inherited from upstream is owner-guarded and
  is not authorization to publish from this derivative.
- Derivative lineage and the supported upstream-import procedure are documented
  in `UPSTREAM.md`.

Use installed HashiCorp Terraform skills when the task needs Terraform-specific
implementation, refactoring, style, test, import, Stack, provider, or policy
guidance. Skill output is implementation guidance; it does not expand the
requested scope or override repository-specific safety rules.

## Scope & Change Control

- Make only the changes required for the requested outcome. Preserve module
  boundaries, names, provider patterns, public inputs and outputs, defaults, and
  unrelated behavior unless the request explicitly changes them.
- Do not combine a functional change with opportunistic Terraform, provider, or
  module upgrades, broad refactors, directory renames, or repository-wide
  formatting.
- Preserve unrelated working-tree changes. Before staging or reporting work,
  inspect the diff and distinguish current-task edits from pre-existing edits.
- Keep upstream imports reviewable and follow `UPSTREAM.md`. Import source
  content without merging upstream Git history into this independent
  derivative.
- Keep module and wrapper sources, examples, documentation, and release
  references pointed at this repository and its neutral derivative release.

Before proceeding, explicitly identify any proposed change that can cause
resource destruction or replacement, downtime, privilege expansion, public
exposure, networking changes, persistent-data impact, backend or state
migration, or material cost changes.

## Terraform Execution Safety

The following non-mutating commands may be run when relevant:

```text
terraform version
terraform fmt -check -recursive
terraform validate
terraform providers
```

Use `terraform init -backend=false` when initialization is necessary for
validation. Do not use `terraform init -upgrade` unless an intentional
dependency upgrade is explicitly in scope.

`terraform plan` requires appropriate provider credentials and environment
context and is not ordinarily necessary for this module library. If a plan is
specifically appropriate and authorized, inspect it for destruction,
replacement, privilege changes, public exposure, networking changes,
persistent-data impact, security-control regressions, and unexpected cost.
Validation alone is not evidence that an infrastructure change is safe. Do not
use `-target` as a routine workflow mechanism.

Never intentionally mutate infrastructure or Terraform state without explicit
user authorization. This includes:

```text
terraform apply
terraform destroy
terraform import
terraform state mv
terraform state rm
terraform state push
terraform taint
terraform untaint
terraform force-unlock
```

Do not use provider-specific commands to mutate managed AWS resources as a
workaround for Terraform. Never enable unattended destructive approval merely
for convenience.

## State, Backend & Credential Safety

- Treat Terraform state, saved plans, crash logs, and provider debug logs as
  sensitive even though this repository does not configure a shared backend.
- Never manually edit or commit state, expose state contents in prompts, logs,
  documentation, or final responses, or disable locking as a workaround.
- Do not add, migrate, or reconfigure a backend, state location, workspace,
  locking scheme, encryption setting, authentication method, or Terraform
  Cloud/HCP binding without explicit approval.
- Do not use `terraform force-unlock` without confirming that no active
  operation owns the lock.
- Never commit AWS credentials, API keys, passwords, tokens, private keys, or
  sensitive local configuration. Use credential metadata rather than secret
  values when diagnosing configuration.

Do not commit any of the following:

```text
.terraform/
*.tfstate
*.tfstate.*
*.tfplan
crash.log
crash.*.log
```

## Provider & Dependency Changes

- Follow existing Terraform and provider constraints; do not introduce
  unbounded provider dependencies.
- Do not upgrade Terraform, providers, or referenced modules incidentally.
- Do not manually edit `.terraform.lock.hcl` or regenerate dependency
  selections merely to resolve a local initialization problem.
- A lockfile change must correspond to an intentional dependency change in the
  same request and must be explained in the PR.
- Do not add a new linter, security scanner, policy framework, wrapper, or
  dependency when repository-native tooling is sufficient.

## Validation by Change Type

Use the smallest repository-native check set that directly exercises the
changed property.

For Terraform configuration changes, normally run:

1. `terraform fmt -check -recursive` from the repository root.
2. `terraform init -backend=false` and `terraform validate` in every affected
   Terraform root.
3. Existing `terraform test` tests only when the repository already contains
   applicable `.tftest.hcl` files.
4. `pre-commit run --all-files` once when the change is ready for repository-wide
   checks.
5. `git diff --check` and a final review of the complete Git diff.

Do not create custom validation harnesses, manifests, journals, evidence
reports, validators for validators, or new test infrastructure merely to prove
an ordinary module edit. Do not repeatedly validate unchanged files. If a
normal check fails, diagnose the module or environment failure, retry once only
when plausibly transient, and fix only failures caused by the requested work.
Report unrelated or environmental failures without changing unrelated files.

Do not claim a command passed unless it was run successfully in the current
work. If validation is incomplete, state exactly what was not run, why, and
what remains unverified. Never run tests that create real infrastructure or
incur cloud costs without authorization.

## Generated & Derivative-Controlled Content

- Do not edit `.terraform/`, saved plans, generated schemas, or other transient
  provider artifacts.
- Terraform-docs sections in READMEs are generated. Change the corresponding
  Terraform source and let the existing pre-commit hook refresh content between
  `BEGIN_TF_DOCS` and `END_TF_DOCS`.
- Wrapper READMEs contain derivative-pinned module sources. Preserve those
  sources and their neutral release references; do not overwrite them with
  upstream wrapper-generator output.
- When an upstream import changes inputs, outputs, provider requirements,
  Terraform constraints, module interfaces, or usage, update the authoritative
  source and relevant derivative documentation together.
- Do not directly edit generated or synchronized content when a repository
  source and established generation path exist. Do not run a generator that
  would replace derivative-specific content.

## IAM & Security Review

For IAM policies, trust policies, permissions boundaries, OIDC federation, or
role assumption changes:

- preserve least privilege;
- reject unnecessary wildcard actions, resources, or principals;
- check for broadened trust relationships and privilege-escalation paths;
- preserve conditions, permissions boundaries, encryption, and explicit
  security controls unless changing them is required;
- identify every intentional security-boundary change in the PR and final
  response.

Do not weaken validation, authentication, authorization, encryption, or another
security control merely to make validation pass.

## Review & Handoff Expectations

For reviews, lead with findings ordered by severity and include file and line
references where possible. Prioritize destructive or replacement behavior,
state and backend changes, IAM or privilege expansion, public exposure,
persistent-data risk, encryption regressions, availability regressions,
dependency-upgrade risk, and unexpected cost. Do not report style preferences
as defects when repository tooling already governs them.

For completed Terraform changes, report:

- the infrastructure or module behavior changed;
- the resources, modules, variables, outputs, policies, and files changed;
- the exact validation commands run and their results;
- plan add/change/destroy/replacement counts only if a plan was actually run;
- relevant state, IAM, networking, migration, downtime, data, cost, and
  unverified risks.

Never call a plan clean when no plan was executed. Once the requested outcome
and proportional acceptance checks pass, stop; optional process machinery and
unrequested improvements do not block completion.
