# Preston-Check Homebrew Tap

Homebrew formula for [Preston-Check](https://github.com/preston-check/preston-check) — pre-deployment fintech security audit, 284 checks across 33 frameworks.

## Install

```bash
brew tap preston-check/preston-check
brew install preston-check
```

After install:

```bash
preston-check --help
preston-check --light                  # quick 30-second scan
preston-check --critical-only          # blocking issues only (~12s)
preston-check --framework "PCI-DSS"    # scoped audit
```

See [the main repository](https://github.com/preston-check/preston-check) for documentation, framework coverage, and Pro/Enterprise tier features.

Apache 2.0 licensed.
