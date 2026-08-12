# IAM neutral derivative execution blocker

Status: blocked again after the five-round authorization-amendment breaker.

- Branch: `neutral/v6.8.0-neutral.1`
- Approved upstream: `terraform-aws-modules/terraform-aws-iam`, tag `v6.8.0`, SHA `d6e381ccfa95b944149c8b14ba4087e517c57ac7`
- Pushed source milestones: `132c9ec` and `f8129aa`
- Final plan amendment: `de0dcc3`

The fifth amendment narrowed the Task 1 pre-commit whitespace gate, but its
scoped re-review tripped the execution breaker. Two load-bearing gaps remain:

1. Checks run before staging ignore untracked imported files.
2. The README blank-at-EOF exception is not bounded by an executable
   byte-exact expected-transform proof.

IAM execution must not receive another fix dispatch in this run. No PR, tag,
or release exists. Persist this blocker, then move to Aurora.
