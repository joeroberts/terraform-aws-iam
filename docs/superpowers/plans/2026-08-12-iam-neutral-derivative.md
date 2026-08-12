# Neutral AWS IAM Module Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create a clean-history, independently maintained derivative of upstream AWS IAM module v6.8.0, remove its nontechnical repository content, and open a fully verified PR for the reserved v6.8.0-neutral.1 release.

**Architecture:** Sanitize the exact upstream tag in temporary storage before any upstream-derived file enters this repository, then import the cleaned tree into the existing neutral worktree. Preserve all Terraform HCL byte-for-byte, add provenance and derivative-facing sources, harden inherited workflows, verify all 24 Terraform roots, and create a PR without publishing the reserved tag.

**Tech Stack:** Terraform 1.15.7, AWS provider >= 6.28, Terraform >= 1.5.7, HCL, terraform-docs 0.20.0, TFLint 0.59.1, actionlint 1.7.7, Git, GitHub CLI

## Global Constraints

- Worktree: `/Users/jroberts/Documents/dev/joeroberts/terraform/.worktrees/terraform-aws-iam/v6.8.0-neutral.1`.
- Branch: `neutral/v6.8.0-neutral.1`; PR base: `main`.
- Baseline upstream tag: `v6.8.0`.
- Resolved upstream commit: `d6e381ccfa95b944149c8b14ba4087e517c57ac7`.
- Reserved release tag: `v6.8.0-neutral.1`; do not create or push it before merge.
- Preserve the Apache 2.0 license, upstream authorship, provider metadata, and contributor links.
- Every changed upstream-derived file begins with `Modified by joeroberts/terraform-aws-iam on 2026-08-12; see UPSTREAM.md.` using the file's comment syntax. `CHANGELOG.md` begins with that dated HTML notice.
- Do not import upstream Git history or create a GitHub-native fork relationship.
- Do not change any Terraform interface or behavior; IAM v6.8.0 has no nontechnical Terraform input to remove.
- Upstream v6.8.0 contains no `*.tftest.hcl`; exact HCL parity and 24-root init/validate are the focused behavioral checks instead of an empty `terraform test` run.
- No disallowed nontechnical material may enter the target working tree or any target commit.
- Pin every inherited `uses:` reference to the verified 40-character commit listed in Task 3 and retain the inherited version as a comment.
- Push every completed milestone commit immediately; never force-push.
- If blocked, persist `docs/neutralization/BLOCKER.md`, push it when possible, open a coherent draft PR, update the IAM campaign status journal, and move to the next repository.

## File Map

- Import: the complete upstream v6.8.0 working tree except `.git/`.
- Modify during pre-import sanitation: `README.md` — remove the banner and final nontechnical section; `CHANGELOG.md` — remove the full identified nontechnical bullet and prepend the dated HTML notice as its first line.
- Modify after import: `README.md`, eight `modules/*/README.md`, and eight `wrappers/*/README.md` — add notices, derivative identity, and pinned Git sources.
- Modify after import: `.github/workflows/lock.yml`, `pr-title.yml`, `pre-commit.yml`, `release.yml`, and `stale-actions.yaml` — add notices, full-SHA pins, and least-privilege permissions.
- Create: `UPSTREAM.md` — exact provenance, intentional delta, attribution, and update procedure.
- Create: `docs/neutralization/CAMPAIGN-STATUS.md` — cross-repository milestone and PR journal.
- Preserve: `docs/superpowers/specs/2026-08-12-neutral-terraform-modules-campaign-design.md` and this plan.
- Preserve without modification: all `*.tf`, including provider metadata and example OIDC subjects that intentionally credit upstream.

---

### Task 1: Sanitized Snapshot Import and Provenance

**Required resumption gate:** Commit and push this documentation-only
authorization amendment to `neutral/v6.8.0-neutral.1` without force before
running or resuming any Task 1 command. Confirm that `HEAD` equals
`@{upstream}` after that push.

**Files:**
- Import: complete upstream working tree except `.git/`
- Modify before copy: `README.md:5,303-307` and `CHANGELOG.md:930` in pristine v6.8.0
- Create: `UPSTREAM.md`

**Interfaces:**
- Consumes: upstream tag `v6.8.0` at `d6e381ccfa95b944149c8b14ba4087e517c57ac7`
- Produces: a target commit containing the complete technical module tree with identical HCL and no disallowed material

- [ ] **Step 1: Verify branch, remote, and clean planning baseline**

Run:

```bash
test "$(git branch --show-current)" = "neutral/v6.8.0-neutral.1"
test "$(git remote get-url origin)" = "git@github.com:joeroberts/terraform-aws-iam.git"
test -z "$(git status --porcelain)"
test "$(git rev-parse '@{upstream}')" = "$(git rev-parse HEAD)"
```

Expected: all assertions pass and the branch contains only the repository bootstrap, approved campaign design, and this implementation plan.

- [ ] **Step 2: Clone and verify the immutable upstream release outside the repository**

Run:

```bash
iam_import_root=$(mktemp -d /private/tmp/terraform-aws-iam-v6.8.0.XXXXXX)
git clone --quiet --depth 1 --branch v6.8.0 \
  https://github.com/terraform-aws-modules/terraform-aws-iam.git \
  "$iam_import_root/source"
test "$(git -C "$iam_import_root/source" rev-parse HEAD)" = \
  "d6e381ccfa95b944149c8b14ba4087e517c57ac7"
git ls-remote https://github.com/terraform-aws-modules/terraform-aws-iam.git \
  refs/tags/v6.8.0
```

Expected: both the local checkout and official tag resolve to the recorded commit.

- [ ] **Step 3: Prove the neutrality acceptance check fails on pristine upstream**

Run:

```bash
iam_neutral_pattern="$(printf '%s|%s|%s|%s|%s|%s|%s' \
  'put''in' 'khuy''lo' 'ukr''ain' 'russ''ia' 'bela''rus' 'cri''mea' 'don''bas')"
test -n "$(rg -l -i "$iam_neutral_pattern" "$iam_import_root/source" \
  --hidden --glob '!.git/**')"
```

Expected: the assertion passes because the pristine README and CHANGELOG contain
material the derivative forbids. This proves the later zero-match check is
meaningful.

- [ ] **Step 4: Neutralize the temporary README and CHANGELOG before copying**

Using `apply_patch` against `$iam_import_root/source/README.md`, delete exactly:

- pristine line 5, the single external political banner; and
- pristine lines 303-307, the final nontechnical section and its three bullets.

Using `apply_patch` against `$iam_import_root/source/CHANGELOG.md`, delete the
full changelog bullet at pristine line 930 without reproducing its text. Then
prepend this first-line notice to both temporary files, with the HTML notice as
the first line of `CHANGELOG.md`:

```markdown
<!-- Modified by joeroberts/terraform-aws-iam on 2026-08-12; see UPSTREAM.md. -->
```

Run:

```bash
if rg -n -i "$iam_neutral_pattern" "$iam_import_root/source" \
  --hidden --glob '!.git/**'; then
  printf 'temporary source neutrality check failed\n' >&2
  exit 1
fi
iam_task1_allowed_files="$(printf '%s\n' CHANGELOG.md README.md)"
test "$(git -C "$iam_import_root/source" diff --name-only | sort)" = \
  "$iam_task1_allowed_files"
```

Expected: no matches and exit status 0. The temporary-snapshot parity
allowlist contains only `README.md` and `CHANGELOG.md`; all HCL remains
byte-identical to upstream.

- [ ] **Step 5: Copy only the sanitized working tree**

Run:

```bash
rsync -a --exclude='/.git/' "$iam_import_root/source/" ./
test -f LICENSE
test -f README.md
test -d modules
test -d examples
test -d wrappers
test -f docs/superpowers/plans/2026-08-12-iam-neutral-derivative.md
iam_task1_parity_root=$(mktemp -d)
mkdir -p "$iam_task1_parity_root/pristine" \
  "$iam_task1_parity_root/source" "$iam_task1_parity_root/target"
git -C "$iam_import_root/source" archive --format=tar \
  --output="$iam_task1_parity_root/pristine.tar" HEAD
tar -xf "$iam_task1_parity_root/pristine.tar" \
  -C "$iam_task1_parity_root/pristine"
for iam_task1_parity_source in "$iam_task1_parity_root/pristine/" ./; do
  if test "$iam_task1_parity_source" = "$iam_task1_parity_root/pristine/"; then
    iam_task1_parity_destination="$iam_task1_parity_root/source/"
  else
    iam_task1_parity_destination="$iam_task1_parity_root/target/"
  fi
  rsync -a --exclude='/.git' --exclude='/.superpowers/' \
    --exclude='/docs/superpowers/' "$iam_task1_parity_source" \
    "$iam_task1_parity_destination"
done
iam_task1_import_diff="$iam_task1_parity_root/diff"
if diff -qr "$iam_task1_parity_root/source" \
  "$iam_task1_parity_root/target" > "$iam_task1_import_diff"; then
  printf 'imported snapshot unexpectedly has no allowed documentation differences\n' >&2
  exit 1
else
  test "$?" -eq 1
fi
test "$(wc -l < "$iam_task1_import_diff" | tr -d ' ')" = "2"
test "$(sed -n \
  "s|^Files $iam_task1_parity_root/source/\\(.*\\) and $iam_task1_parity_root/target/\\1 differ$|\\1|p" \
  "$iam_task1_import_diff" | sort)" = "$iam_task1_allowed_files"
```

Expected: the upstream tree is present, the planning documents remain present, and no upstream `.git` directory was copied.

The executable imported-snapshot parity check materializes the already-verified
clone's pristine `HEAD` locally with `git archive`, then uses the same
root-anchored rsync filters for the pristine reference and target copies. It
excludes only root repository and planning artifacts (`/.git` as either a file
or directory, `/.superpowers/`, and `/docs/superpowers/`) and proves the same
non-HCL neutrality-edit allowlist as the temporary snapshot: only `README.md`
and `CHANGELOG.md` may differ from pristine upstream for neutrality.
`CHANGELOG.md` retains the dated HTML notice as its first line; every `*.tf`
remains byte-identical.

- [ ] **Step 6: Add exact provenance**

Create `UPSTREAM.md` with these facts and sections:

```markdown
# Upstream provenance

This repository is an independently maintained derivative of
[terraform-aws-modules/terraform-aws-iam](https://github.com/terraform-aws-modules/terraform-aws-iam).
It is not a GitHub-native fork.

## Current baseline

- Upstream tag: v6.8.0
- Resolved commit: d6e381ccfa95b944149c8b14ba4087e517c57ac7
- Import date: 2026-08-12
- Reserved neutral release: v6.8.0-neutral.1

The derivative omits nontechnical repository content. The selected upstream
release has no corresponding Terraform input or creation gate, so all HCL,
interfaces, and AWS behavior are unchanged.

Upstream authorship and contributor credit are retained. `joeroberts` maintains
this derivative. Every changed upstream-derived file carries a dated notice
that points to this record.

## Updating

1. Clone the exact new upstream tag into temporary storage and record its SHA.
2. Review the full upstream diff and neutralize it before copying any file here.
3. Reapply modification notices and derivative-facing source links.
4. Re-resolve inherited Actions and retain full-SHA pins and minimum permissions.
5. Regenerate docs and run formatting, lint, validation, parity, neutrality,
   history, and workflow checks.
6. Open a PR; publish the neutral tag only after review and merge.

Never merge an upstream branch directly into this repository.
```

- [ ] **Step 7: Prove all imported HCL is identical to upstream**

Run:

```bash
while IFS= read -r iam_tf_file; do
  diff -u "$iam_import_root/source/$iam_tf_file" "$iam_tf_file"
done < <(git -C "$iam_import_root/source" ls-files '*.tf' | sort)
```

Expected: no output. IAM neutralization changes repository documentation only.

- [ ] **Step 8: Commit and push the sanitized import**

Run:

```bash
terraform fmt -check -recursive
git diff --check
git add . ':!docs/superpowers'
git commit -m "feat: import neutral IAM module v6.8.0"
git push
```

Expected: one import commit is pushed; no target commit contains the pristine
nontechnical README content or the removed CHANGELOG bullet. The Task 1
non-HCL neutrality-edit allowlist contains only `README.md` and
`CHANGELOG.md`.

---

### Task 2: Derivative Consumer Documentation

**Files:**
- Modify: `README.md`
- Modify: `modules/{iam-account,iam-group,iam-oidc-provider,iam-policy,iam-read-only-policy,iam-role-for-service-accounts,iam-role,iam-user}/README.md`
- Modify: `wrappers/{iam-account,iam-group,iam-oidc-provider,iam-policy,iam-read-only-policy,iam-role-for-service-accounts,iam-role,iam-user}/README.md`

**Interfaces:**
- Consumes: sanitized v6.8.0 tree and reserved tag name from Task 1
- Produces: derivative identity plus copyable root, submodule, Terraform wrapper, and Terragrunt sources pinned to `v6.8.0-neutral.1`

- [ ] **Step 1: Run the consumer-source acceptance check before editing**

Run:

```bash
test -n "$(rg -l 'terraform-aws-modules/iam/aws|tfr:///terraform-aws-modules/iam/aws' \
  README.md modules wrappers -g README.md)"
```

Expected: the assertion passes because 17 active README files still direct consumers to the upstream Registry.

- [ ] **Step 2: Add derivative identity, navigation, and attribution boundaries**

After the opening description in `README.md`, add:

```markdown
This repository is an independently maintained derivative of upstream
v6.8.0. See [UPSTREAM.md](UPSTREAM.md) for provenance, compatibility details,
and the update process. Consumers should pin the reserved neutral release shown
below after it is published following PR review and merge.
```

Keep Anton Babenko and the upstream contributors credited. Add a separate
sentence identifying `joeroberts` as derivative maintainer, replace the remote
license URL with `[LICENSE](LICENSE)`, and replace the shared upstream example
prefix with
`https://github.com/joeroberts/terraform-aws-iam/tree/v6.8.0-neutral.1/examples/`
for the eight links named in the exact module set below.

- [ ] **Step 3: Replace active module and wrapper source addresses**

For each module name in the exact set below, use `apply_patch` to replace active
Registry sources in the root/module README with its pinned Git subdirectory:

```text
iam-account
iam-group
iam-oidc-provider
iam-policy
iam-read-only-policy
iam-role-for-service-accounts
iam-role
iam-user
```

The required bulk mapping is:

```bash
for iam_module_name in iam-account iam-group iam-oidc-provider iam-policy \
  iam-read-only-policy iam-role-for-service-accounts iam-role iam-user; do
  iam_module_source="git::ssh://git@github.com/joeroberts/terraform-aws-iam.git//modules/$iam_module_name?ref=v6.8.0-neutral.1"
  printf '%s -> %s\n' "$iam_module_name" "$iam_module_source"
done
```

For every matching wrapper README, replace Terraform, Terragrunt, and commented
Git alternatives using this complete mapping:

```bash
for iam_wrapper_name in iam-account iam-group iam-oidc-provider iam-policy \
  iam-read-only-policy iam-role-for-service-accounts iam-role iam-user; do
  iam_wrapper_source="git::ssh://git@github.com/joeroberts/terraform-aws-iam.git//wrappers/$iam_wrapper_name?ref=v6.8.0-neutral.1"
  printf '%s -> %s\n' "$iam_wrapper_name" "$iam_wrapper_source"
done
```

Do not rewrite historical migration snippets in `docs/UPGRADE-6.0.md`, upstream
contributor links, provider metadata, or example OIDC subject values.

- [ ] **Step 4: Add required notices to all newly modified upstream documents**

Prepend the HTML notice below to each of the 16 module/wrapper README files.
`README.md` already has the same notice from Task 1.

```markdown
<!-- Modified by joeroberts/terraform-aws-iam on 2026-08-12; see UPSTREAM.md. -->
```

- [ ] **Step 5: Prove consumer sources are derivative-owned and documentation is stable**

Run:

```bash
if rg -n 'source\s*=\s*"(terraform-aws-modules/iam/aws|tfr:///terraform-aws-modules/iam/aws)' \
  README.md modules wrappers -g README.md; then
  printf 'active upstream IAM source remains\n' >&2
  exit 1
fi
test "$(rg -l 'v6\.8\.0-neutral\.1' README.md modules wrappers -g README.md | wc -l | tr -d ' ')" = "17"
iam_docs_before=$(git diff -- README.md modules wrappers | shasum -a 256)
while IFS= read -r iam_docs_dir; do
  go run github.com/terraform-docs/terraform-docs@v0.20.0 markdown table \
    --lockfile=false --output-file README.md --output-mode inject "$iam_docs_dir"
done < <(rg -l '<!-- BEGIN_TF_DOCS -->' -g README.md | xargs -n1 dirname | sort -u)
test "$iam_docs_before" = "$(git diff -- README.md modules wrappers | shasum -a 256)"
```

Expected: no active upstream consumer source remains, exactly 17 README files reference the reserved tag, and terraform-docs changes nothing.

- [ ] **Step 6: Commit and push consumer documentation**

Run:

```bash
git diff --check
git add README.md modules/*/README.md wrappers/*/README.md
git commit -m "docs: point IAM consumers to neutral release"
git push
```

Expected: one documentation-only milestone is pushed.

---

### Task 3: Inherited Workflow Hardening

**Files:**
- Modify: `.github/workflows/lock.yml`
- Modify: `.github/workflows/pr-title.yml`
- Modify: `.github/workflows/pre-commit.yml`
- Modify: `.github/workflows/release.yml`
- Modify: `.github/workflows/stale-actions.yaml`

**Interfaces:**
- Consumes: five upstream workflows and verified official action refs
- Produces: inert automatic release behavior, full-SHA action pins, modification notices, and explicit minimum token permissions

- [ ] **Step 1: Prove the full-SHA acceptance check fails before editing**

Run:

```bash
test -n "$(rg -n -P 'uses:\s+[^\s#]+@(?![0-9a-f]{40}(?:\s|$))' .github/workflows)"
```

Expected: the assertion passes because inherited action tags and a major branch remain.

- [ ] **Step 2: Apply the verified action mapping**

Use `apply_patch` to replace every inherited ref with the exact SHA and retain
the old ref as an end-of-line comment:

| Inherited ref | Verified commit |
| --- | --- |
| `actions/checkout@v5` | `fbc6f3992d24b796d5a048ff273f7fcc4a7b6c09 # v5` |
| `actions/setup-node@v6` | `249970729cb0ef3589644e2896645e5dc5ba9c38 # v6` |
| `actions/stale@v10` | `1e223db275d687790206a7acac4d1a11bd6fe629 # v10` |
| `amannn/action-semantic-pull-request@v6.1.1` | `48f256284bd46cdaab1048c3721360e808335d50 # v6.1.1` |
| `clowdhaus/terraform-composite-actions/directories@v1.14.0` | `462243b714d762cbcac6732098e9fdb4ab236cb7 # v1.14.0` |
| `clowdhaus/terraform-composite-actions/pre-commit@v1.14.0` | `462243b714d762cbcac6732098e9fdb4ab236cb7 # v1.14.0` |
| `clowdhaus/terraform-min-max@v2.1.0` | `a86951cbe89f4d15caec805f36aa1dd68863ae32 # v2.1.0` |
| `cycjimmy/semantic-release-action@v5` | `ba330626c4750c19d8299de843f05c7aa5574f62 # v5 branch; tag v5.0.2` |
| `dessant/lock-threads@v5` | `1bf7ec25051fe7c00bdd17e6a7cf3d7bfb7dc771 # v5` |
| `jaxxstorm/action-install-gh-release@v2.1.0` | `6096f2a2bbfee498ced520b6922ac2c06e990ed2 # v2.1.0` |

- [ ] **Step 3: Add notices and explicit permissions**

Prepend this YAML comment to all five workflow files:

```yaml
# Modified by joeroberts/terraform-aws-iam on 2026-08-12; see UPSTREAM.md.
```

Add these top-level permission maps after each `on:` block:

| Workflow | Permissions |
| --- | --- |
| `lock.yml` | `issues: write`, `pull-requests: write` |
| `pr-title.yml` | `pull-requests: read` |
| `pre-commit.yml` | `contents: read` |
| `release.yml` | `contents: read` |
| `stale-actions.yaml` | `issues: write`, `pull-requests: write` |

Keep the release job's upstream-owner guard unchanged. It evaluates false in
`joeroberts/terraform-aws-iam`, so neither pushes nor manual dispatches publish
a derivative release during this PR.

- [ ] **Step 4: Validate pins, permissions, and workflow syntax**

Run:

```bash
if rg -n -P 'uses:\s+[^\s#]+@(?![0-9a-f]{40}(?:\s|$))' .github/workflows; then
  printf 'unpinned action remains\n' >&2
  exit 1
fi
test "$(rg -l '^permissions:' .github/workflows | wc -l | tr -d ' ')" = "5"
go run github.com/rhysd/actionlint/cmd/actionlint@v1.7.7
```

Expected: no unpinned actions, five explicit permission blocks, and no actionlint errors.

- [ ] **Step 5: Commit and push workflow hardening**

Run:

```bash
git diff --check
git add .github/workflows
git commit -m "ci: pin and restrict inherited workflows"
git push
```

Expected: one CI-only milestone is pushed.

---

### Task 4: Full Compatibility and Neutrality Verification

**Files:**
- Verify: complete tracked tree and complete target history
- Do not create: tracked lock files, plans, state, caches, or test artifacts

**Interfaces:**
- Consumes: Tasks 1-3
- Produces: reproducible evidence for HCL parity, documentation stability, formatting, lint, initialization, validation, workflow safety, neutrality, and remote synchronization

- [ ] **Step 1: Re-run stable docs, formatting, and TFLint**

Run:

```bash
while IFS= read -r iam_docs_dir; do
  go run github.com/terraform-docs/terraform-docs@v0.20.0 markdown table \
    --lockfile=false --output-file README.md --output-mode inject "$iam_docs_dir"
done < <(rg -l '<!-- BEGIN_TF_DOCS -->' -g README.md | xargs -n1 dirname | sort -u)
git diff --exit-code
terraform fmt -check -recursive
iam_tflint_tmp=$(mktemp -d)
curl -fsSL https://github.com/terraform-linters/tflint/releases/download/v0.59.1/tflint_darwin_arm64.zip \
  -o "$iam_tflint_tmp/tflint.zip"
unzip -q "$iam_tflint_tmp/tflint.zip" -d "$iam_tflint_tmp"
"$iam_tflint_tmp/tflint" --recursive \
  --only=terraform_deprecated_interpolation \
  --only=terraform_deprecated_index \
  --only=terraform_unused_declarations \
  --only=terraform_comment_syntax \
  --only=terraform_documented_outputs \
  --only=terraform_documented_variables \
  --only=terraform_typed_variables \
  --only=terraform_module_pinned_source \
  --only=terraform_naming_convention \
  --only=terraform_required_version \
  --only=terraform_required_providers \
  --only=terraform_standard_module_structure \
  --only=terraform_workspace_remote
```

Expected: docs are stable and formatting plus all inherited lint rules pass.

- [ ] **Step 2: Initialize and validate all 24 Terraform roots**

Run:

```bash
iam_plugin_cache=$(mktemp -d)
iam_root_count=0
while IFS= read -r iam_tf_dir; do
  iam_root_count=$((iam_root_count + 1))
  printf 'Validating %s\n' "$iam_tf_dir"
  TF_PLUGIN_CACHE_DIR="$iam_plugin_cache" terraform -chdir="$iam_tf_dir" \
    init -backend=false -input=false
  TF_PLUGIN_CACHE_DIR="$iam_plugin_cache" terraform -chdir="$iam_tf_dir" validate
done < <(rg --files -g versions.tf | xargs -n1 dirname | sort -u)
test "$iam_root_count" = "24"
```

Expected: all eight examples, eight modules, and eight wrappers initialize and validate without AWS credentials.

- [ ] **Step 3: Re-prove exact HCL parity from a fresh checkout**

Run:

```bash
iam_compare_root=$(mktemp -d /private/tmp/terraform-aws-iam-compare.XXXXXX)
git clone --quiet --depth 1 --branch v6.8.0 \
  https://github.com/terraform-aws-modules/terraform-aws-iam.git \
  "$iam_compare_root/upstream"
test "$(git -C "$iam_compare_root/upstream" rev-parse HEAD)" = \
  "d6e381ccfa95b944149c8b14ba4087e517c57ac7"
while IFS= read -r iam_tf_file; do
  diff -u "$iam_compare_root/upstream/$iam_tf_file" "$iam_tf_file"
done < <(git -C "$iam_compare_root/upstream" ls-files '*.tf' | sort)
```

Expected: no output for any Terraform file.

- [ ] **Step 4: Audit notices, sources, workflows, neutrality, and full history**

Run:

```bash
iam_notice='Modified by joeroberts/terraform-aws-iam on 2026-08-12; see UPSTREAM.md.'
for iam_notice_file in README.md CHANGELOG.md modules/*/README.md wrappers/*/README.md .github/workflows/*; do
  head -n 1 "$iam_notice_file" | rg -Fq "$iam_notice"
done
head -n 1 CHANGELOG.md | rg -Fx '<!-- Modified by joeroberts/terraform-aws-iam on 2026-08-12; see UPSTREAM.md. -->'
if rg -n 'source\s*=\s*"(terraform-aws-modules/iam/aws|tfr:///terraform-aws-modules/iam/aws)' \
  README.md modules wrappers -g README.md; then exit 1; fi
if rg -n -P 'uses:\s+[^\s#]+@(?![0-9a-f]{40}(?:\s|$))' .github/workflows; then exit 1; fi
go run github.com/rhysd/actionlint/cmd/actionlint@v1.7.7
iam_neutral_pattern="$(printf '%s|%s|%s|%s|%s|%s|%s' \
  'put''in' 'khuy''lo' 'ukr''ain' 'russ''ia' 'bela''rus' 'cri''mea' 'don''bas')"
if rg -n -i "$iam_neutral_pattern" . --hidden --glob '!.git/**' --glob '!.terraform/**'; then exit 1; fi
if git grep -nEi "$iam_neutral_pattern" $(git rev-list --all); then exit 1; fi
```

Expected: every assertion passes with zero disallowed tree or history matches.

- [ ] **Step 5: Confirm the candidate is clean and synchronized**

Run:

```bash
git diff --check
test -z "$(git status --porcelain)"
git fetch origin neutral/v6.8.0-neutral.1
test "$(git rev-parse HEAD)" = "$(git rev-parse origin/neutral/v6.8.0-neutral.1)"
test -z "$(git tag -l v6.8.0-neutral.1)"
test -z "$(git ls-remote --tags origin refs/tags/v6.8.0-neutral.1)"
```

Expected: clean branch equals its remote and the reserved tag does not exist locally or remotely.

---

### Task 5: Independent Review, Campaign Journal, and Pull Request

**Files:**
- Create or modify: `docs/neutralization/CAMPAIGN-STATUS.md`
- Modify only if review requires: files already listed in Tasks 1-3
- External write: GitHub pull request targeting `main`

**Interfaces:**
- Consumes: fully verified candidate from Task 4
- Produces: independently reviewed branch, persisted campaign status, and a reviewable PR with tagging explicitly deferred

- [ ] **Step 1: Obtain independent requirements and code-quality reviews**

Dispatch a fresh reviewer using the `superpowers:requesting-code-review` workflow. Give the reviewer the approved design, this plan, upstream tag/SHA, the complete `main...HEAD` diff, and Task 4 evidence. Require separate findings for requirements compliance and code quality, with file/line evidence and no implementation by the reviewer.

Expected: both review passes return no unresolved load-bearing finding. If they do, fix the smallest compliant scope, commit as `fix: address independent review findings`, push, rerun Task 4, and request a fresh re-review.

- [ ] **Step 2: Create the PR without creating a tag**

Run:

```bash
gh pr create \
  --repo joeroberts/terraform-aws-iam \
  --base main \
  --head neutral/v6.8.0-neutral.1 \
  --title "feat: add neutral IAM module v6.8.0" \
  --body-file /private/tmp/terraform-aws-iam-pr-body.md
```

Before running it, create the temporary body with: upstream tag and full SHA;
clean-history derivative explanation; documentation-only neutralization scope;
Apache notices and attribution; workflow pins and permissions; all verification
evidence; independent-review result; and an explicit statement that
`v6.8.0-neutral.1` will not be published until review and merge.

Expected: GitHub returns one open PR URL targeting `main`.

- [ ] **Step 3: Persist campaign status and push the final documentation milestone**

Create `docs/neutralization/CAMPAIGN-STATUS.md` with a four-row table for IAM,
RDS Aurora, Security Groups, and RDS. Record IAM as `PR open` with its branch,
final commit, PR URL, verification summary, and `tag deferred`; record the other
three as `planned` with their neutral branches and reserved tags.

Run:

```bash
git add docs/neutralization/CAMPAIGN-STATUS.md
git commit -m "docs: record IAM campaign milestone"
git push
gh pr view --repo joeroberts/terraform-aws-iam --json url,state,baseRefName,headRefName,commits,statusCheckRollup
```

Expected: the journal commit appears in the open PR and GitHub reads back the correct base/head branches. Do not wait for the user to merge; move to the RDS Aurora plan.
