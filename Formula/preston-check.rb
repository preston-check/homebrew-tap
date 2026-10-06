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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.531/preston-check-1.8.531.tar.gz"
  sha256 "2f4f2c8510514102694b6fef88daf68c694df54742d3481474c04124ea445874"
  license "Apache-2.0"
  version "1.8.531"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.531"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59f6dc87cb3430e794832f425b473b5a477930e1fb2e3a520e26c4b867cdfc8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c8d55e87d241c09aa238b1b4e2cc4eaa6b8729baa60a7ea00d583592a63c12c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7613e33d0730554ab0450e7cfb8b85a1dadfed5b6098dc006271d2ecf7ba4ad8"
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
