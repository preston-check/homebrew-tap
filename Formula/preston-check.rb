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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.264/preston-check-1.8.264.tar.gz"
  sha256 "bcb1187c99bde2c644a7dd6a6979457e3afaa409e1e44e9c3748a34fa660918f"
  license "Apache-2.0"
  version "1.8.264"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.264"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "337e9158c1d569faf76f59a753ea45344bcf112337f32db7d5e79daef6284ef8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e67d82f8d64900e07f1177d42f2f1c606f21d1642f58c04f8f540e010fae4b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38274f90a1540fb8391ce37b78a92a0e35f759397a0ebc0ff95f5038b5e7f163"
    sha256 cellar: :any_skip_relocation, sequoia:       "f380150c6b2bd53621f759b61d2bf3b98b9b1f1972534020412668a89d76b6ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0165ad40ec2525b2d2d1b23dbf801c3964810dba23772d4866f22b05743f6a9e"
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
