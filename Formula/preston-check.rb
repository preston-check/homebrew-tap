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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.239/preston-check-1.8.239.tar.gz"
  sha256 "f002627c11a954f51e0b5221620e50be5a0d4a8fc57f27a403e5d1bb548e4d29"
  license "Apache-2.0"
  version "1.8.239"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.239"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c99a771e5521908ac191d62173dba625c9e62a55472a0cd67a371421e2e16d51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e90a93dc7d32c72262dee866ccf106d8ade36d8b0618e579940dea22a634b4a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd3832f948f334375830afaba9d9c8020d8c2a3d22df364aa8e5deea18e71a58"
    sha256 cellar: :any_skip_relocation, sequoia:       "3505b8dc1303129d158ce2b81d53c1265abeb216ae11ae0e41c8c6bb6a6c6800"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ef2893cb6094939acf1781260d8300f2c82f63c2dbd6633b19db0152a7a0f2b"
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
