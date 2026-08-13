# IAM neutralization blocker

Status: blocked after the five-round authorization-amendment breaker.

## Scope

- Upstream: `terraform-aws-modules/terraform-aws-iam`
- Upstream tag: `v6.8.0`
- Upstream SHA: `d6e381ccfa95b944149c8b14ba4087e517c57ac7`
- Branch: `neutral/v6.8.0-neutral.1`
- Current source milestones: `132c9ec`, `f8129aa`
- Current plan amendment: `de0dcc3`

## Verification that passed

- Neutrality verification passed for the authorized sanitized snapshot.
- HCL parity passed for all 99 imported HCL files.
- The authorized documentation whitespace was restored exactly.

## What remains unsafe

The pre-staging checks inspect Git diffs and therefore ignore untracked
imported files. In addition, the README blank-at-EOF exception lacks an
executable, byte-exact expected-transform proof that bounds the exception to
the authorized result.

## Safe resumption criteria

1. Stage the intended import first, then run the cached checks against the
   staged content.
2. Add an executable exact expected README/CHANGELOG transform comparison.
3. Obtain an independent review before opening any PR.

No PR, tag, or release exists. Do not resume IAM work until these criteria are
met; continue with Aurora instead.
