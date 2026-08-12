# IAM neutral derivative execution blocker

Status: resolved by user authorization; implementation resumed.

- Branch: `neutral/v6.8.0-neutral.1`
- Approved upstream: `terraform-aws-modules/terraform-aws-iam`, tag `v6.8.0`, SHA `d6e381ccfa95b944149c8b14ba4087e517c57ac7`
- The prior README-only parity allowance conflicted with the repository-wide neutrality requirement because the mandated full-tree check found a prohibited upstream match at `CHANGELOG.md:930`.
- The user authorized removal of that full changelog bullet from the temporary imported snapshot, with a dated HTML modification notice as the first line of `CHANGELOG.md`; the Task 1 parity and notice expectations were amended accordingly.
- At the time of this amendment, no source import, PR, tag, or release has been created.

The authorization resolves the documented blocker. Implementation may resume on
IAM only after this documentation-only amendment is committed and pushed
without force; no upstream source has been imported at amendment time.
