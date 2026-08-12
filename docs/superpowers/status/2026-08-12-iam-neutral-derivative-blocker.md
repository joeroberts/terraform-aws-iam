# IAM neutral derivative execution blocker

Status: blocked on the approved neutral-derivative import path.

- Branch: `neutral/v6.8.0-neutral.1`
- Approved upstream: `terraform-aws-modules/terraform-aws-iam`, tag `v6.8.0`, SHA `d6e381ccfa95b944149c8b14ba4087e517c57ac7`
- The README-only parity allowance conflicts with the repository-wide neutrality requirement: the mandated full-tree check still finds a prohibited upstream match outside the permitted README changes.
- The extra upstream match is `CHANGELOG.md:930`.
- No import/source commit, PR, tag, or release was created.

Safe resolution requires explicit authorization to neutralize the `CHANGELOG.md` entry and to update the parity and notice expectations accordingly. Per the user's blocker instruction, execution moved to Aurora.
