# Homebrew formula for Preston-Check
#
# Tap setup (one-time):
#   brew tap preston-check/tap
#
# Install:
#   brew install preston-check
#
# The version, URL, SHA256, and bottle block are updated by the release
# pipeline on each tagged release.

class PrestonCheck < Formula
  desc "Pre-deployment security audit for fintech and financial systems"
  homepage "https://preston-check.com"
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.95/preston-check-1.8.95.tar.gz"
  sha256 "577551922ff2bf5145fcf89b9b8ca30417e3d09b0fbd9dadd1c659569835c38e"
  license "Apache-2.0"
  version "1.8.95"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.95"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7962ab3df5848be04f541f834fde16184be259ced01e7911667e66e5a242dfa5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6545a9f98f738a763f6137cb12bf2fd918e515deb67ee64718155d552ac5348"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1d19344f8e83f1da4ea6b3a92f84f226bbafebffaf2cbfe12c8ea0a4882d9b0"
    sha256 cellar: :any_skip_relocation, sequoia:       "54a72094e0222a94a79b98981f6d0ba04bae148f145c3f77ffa4221dfcee0c5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67dc894cb306a2e314157577e41140027714903dd9c723981ccd3be1b8ad4f94"
  end































































































  depends_on "bash"
  depends_on "gawk"
  depends_on "grep"
  depends_on "coreutils"
  uses_from_macos "openssl"

  def install
    libexec.install Dir["*"]
    {
      "preston-check"               => "preston-check.sh",
      "preston-check-issue-license" => "tools/issue-license.sh",
      "preston-check-setup-key"     => "tools/setup-signing-key.sh",
    }.each do |bin_name, script|
      (bin/bin_name).write <<~SH
        #!/bin/bash
        DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        exec "$DIR/../libexec/#{script}" "$@"
      SH
      chmod 0755, bin/bin_name
    end
  end

  def caveats
    <<~EOS
      Preston-Check is installed. Free tier runs without any setup.

      To run a scan in the current directory:
        preston-check

      To run with a specific config:
        preston-check --config /path/to/myapp.yml

      For Pro/Enterprise tier, install your license at:
        ~/.preston-check/license

      If brew install fails (e.g. on a beta macOS without a bottle yet):
        curl -fsSL https://github.com/preston-check/preston-check/releases/latest/download/install.sh | sh

      Documentation: https://preston-check.com
    EOS
  end

  test do
    assert_match "PRESTON-CHECK", shell_output("#{bin}/preston-check --help")
  end
end
