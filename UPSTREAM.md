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
