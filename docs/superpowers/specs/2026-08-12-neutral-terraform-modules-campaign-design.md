# Neutral Terraform Modules Campaign Design

**Date:** 2026-08-12  
**Status:** Approved for implementation planning  
**Owner:** joeroberts

## Objective

Create independently maintained, politically neutral derivatives of four
`terraform-aws-modules` repositories while preserving their technical behavior,
Apache 2.0 licensing obligations, upstream attribution, and an auditable update
path.

The derivatives must not be GitHub-native forks and must not import disallowed
nontechnical content into either their current trees or their Git histories.

## Repositories and baselines

| Target repository | Upstream repository | Baseline tag | Resolved commit | Reserved neutral tag |
| --- | --- | --- | --- | --- |
| `joeroberts/terraform-aws-iam` | `terraform-aws-modules/terraform-aws-iam` | `v6.8.0` | `d6e381ccfa95b944149c8b14ba4087e517c57ac7` | `v6.8.0-neutral.1` |
| `joeroberts/terraform-aws-rds` | `terraform-aws-modules/terraform-aws-rds` | `v7.2.1` | `9920097a40175c084c46fee1c306fa61cdbaf823` | `v7.2.1-neutral.1` |
| `joeroberts/terraform-aws-rds-aurora` | `terraform-aws-modules/terraform-aws-rds-aurora` | `v10.2.0` | `2c3946c8191278ad974bbb077da5e03986e24f4d` | `v10.2.0-neutral.1` |
| `joeroberts/terraform-aws-security-groups` | `terraform-aws-modules/terraform-aws-security-group` | `v6.0.0` | `58d8e895915f5573767081142d063b7caf7a2b47` | `v6.0.0-neutral.1` |

The local and target GitHub repository is named
`terraform-aws-security-groups`; this intentionally resolves the misspelling in
the original request and differs from the singular upstream repository name.

## Selected derivative model

Each target will use a clean-history independent derivative:

1. Retrieve and verify the exact upstream tag and resolved commit in temporary
   storage.
2. Neutralize the snapshot before any upstream-derived file is copied into a
   target worktree.
3. Import the sanitized snapshot as a new commit descended from the target
   repository's `main` branch.
4. Never merge an upstream branch or import upstream Git history.

This matches the model used by `joeroberts/terraform-aws-s3`. It avoids both a
GitHub fork relationship and historical retention of the removed material.

## Repository isolation and Git workflow

All edits, commits, checks, and PR preparation occur in linked Git worktrees
under the campaign-level `.worktrees/<repository>/<neutral-version>` directory.
The primary repository checkouts remain untouched.

IAM and RDS begin as empty GitHub repositories. Each receives a single empty
`main` initialization commit created from a bootstrap worktree. Aurora and
Security Groups retain their existing license-only `main` histories. Feature
branches use `neutral/<neutral-version>` and target `main` in pull requests.

Milestone commits are pushed as they are completed. Direct pushes of module
implementation commits to `main` are prohibited.

## Neutralization scope

All four upstream snapshots contain nontechnical political repository content
in their README files. RDS, Aurora, and Security Group additionally expose a
nontechnical Boolean input that participates in creation logic and is forwarded
by wrappers. IAM does not expose that input at its selected baseline.

The implementation will:

- Remove the nontechnical README banner and associated prose.
- Remove the nontechnical input and generated documentation entry wherever it
  exists.
- Remove wrapper forwarding for that input.
- Replace creation expressions with the corresponding technical creation input
  alone, preserving behavior for consumers using upstream defaults.
- Scan the complete working tree and complete derivative history for all known
  spellings and related disallowed material.

No unrelated functional change is permitted.

## Licensing, attribution, and provenance

Each derivative retains the complete upstream Apache 2.0 `LICENSE` and upstream
authorship and contributor credit. A derivative-facing maintainer statement may
identify `joeroberts` without replacing upstream attribution.

Every changed upstream-derived file receives a dated, file-level modification
notice that points to `UPSTREAM.md`, satisfying Apache 2.0 section 4(b).
Derivative-owned files do not require that notice.

Each repository adds `UPSTREAM.md` containing:

- Upstream repository URL, exact tag, and full resolved commit.
- Import date and reserved neutral version.
- A concise list of intentional differences.
- Maintainer and attribution boundaries.
- A repeatable update procedure that requires pre-import neutralization.

## Documentation and module sources

Derivative-facing README examples will use Git sources under the `joeroberts`
organization and the reserved neutral tag. These references may be present in
an unmerged PR before the tag exists; they become resolvable only after the PR
is merged and the approved release tag is published.

Self-references, wrapper sources, repository navigation links, and local license
links will be adjusted to the derivative repository. Unrelated third-party
example dependencies remain on their upstream sources unless a direct neutral
portfolio dependency is necessary to keep an example free of the removed
runtime gate. Such changes must be enumerated in the repository-specific plan.

## Workflow security and release behavior

Inherited GitHub Actions will be pinned to verified full commit SHAs while
retaining comments that identify their upstream version or major branch.
Workflow-level or job-level `permissions` will be reduced to the minimum needed
by each job. `actionlint` must pass.

Upstream automatic-release behavior will not publish a derivative release
during PR implementation. Any owner checks, secrets, or triggers that could
create misleading or accidental releases will be disabled or adapted in a
documented change.

Reserved tags are not pushed before the corresponding PR is reviewed and
merged. Tagging and release creation are separate post-merge actions.

## Planning and execution order

All four repository-specific implementation plans will be written, reviewed,
committed, and pushed before module import begins. Each plan lives on its own
repository's neutral branch at
`docs/superpowers/plans/2026-08-12-<module>-neutral-derivative.md`. This campaign
design remains the canonical cross-repository design on the IAM neutral branch.

Implementation then proceeds sequentially:

1. IAM
2. RDS Aurora
3. Security Groups
4. RDS

This order establishes the simplest derivative first and prepares neutral
portfolio dependencies before the RDS example graph is finalized. A PR is
created only after a repository passes its verification and independent review.
Once the PR exists, work moves to the next repository.

## Milestones per repository

Each repository uses small, reviewable, pushed milestones:

1. Repository bootstrap and approved planning documents.
2. Sanitized upstream snapshot import and technical neutralization.
3. Provenance, licensing notices, and derivative-facing documentation.
4. Workflow pinning and least-privilege hardening.
5. Verification and independent-review corrections.
6. Final branch push and pull request creation.

Milestones may be combined only when the repository-specific plan explains why
separating them would create an invalid intermediate state.

## Verification contract

Before PR creation, every derivative must pass:

- Verification that the recorded upstream tag resolves to the recorded commit.
- A clean working-tree scan and a complete-history scan for disallowed content.
- `terraform fmt -check -recursive`.
- Stable `terraform-docs` regeneration using `--lockfile=false` where supported.
- TFLint with the inherited repository configuration.
- `terraform init -backend=false` and `terraform validate` in every distinct
  Terraform root.
- `terraform test` where the repository supplies tests or where focused local
  structural tests are practical.
- Explicit structural assertions proving the removed creation gate now depends
  only on the appropriate technical creation input.
- Upstream-to-derivative parity analysis allowing only documented
  neutralization, provenance, source, legal-notice, and CI changes.
- Full-SHA action-reference audit and `actionlint`.
- A clean-tree check after validation completes.
- Independent requirements and code-quality review by a fresh reviewer.

Security Groups additionally must regenerate its catalog-driven modules and
prove the generated tree remains synchronized. Validation will cover all of its
generated Terraform roots without creating AWS resources.

## Blocker persistence

If safe progress on a repository becomes impossible, the agent will not stall
the whole campaign. It will:

1. Record the failed command, evidence, completed work, exact blocking
   condition, and required next action in
   `docs/neutralization/BLOCKER.md` on the feature branch.
2. Commit and push that record when GitHub remains available.
3. Open a draft PR when the branch is coherent and reviewable.
4. Add the branch, commit, PR if any, and blocker summary to the canonical
   `docs/neutralization/CAMPAIGN-STATUS.md` journal on the IAM neutral branch.
   Push that journal update if GitHub is reachable; otherwise retain the local
   commit and record the failed push in the same entry.
5. Move to the next repository without representing the blocked repository as
   complete.

## Pull-request and completion policy

A repository is complete for this campaign only when:

- All planned commits have been pushed.
- Verification and independent review pass.
- The branch is clean and matches its remote tip.
- A PR targeting `main` exists and accurately summarizes provenance,
  intentional deltas, validation evidence, and deferred tagging.

Creating the PR authorizes moving to the next repository. Merging, publishing
the reserved tag, and creating a GitHub release remain user-reviewed post-merge
steps.
