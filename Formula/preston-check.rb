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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.556/preston-check-1.8.556.tar.gz"
  sha256 "6a8d721d994763f8553feab60d664dfcc38c6fd676fff709b5aa9565393a3f77"
  license "Apache-2.0"
  version "1.8.556"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.556"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "171aa8baa96f196fb047a9e58c2d73f86ffec98a67215240c806a193d0e5569d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "097fb9828248963977f65858e07ef954d0d32c980c1a66368f9450307a4aad53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8dd93719f3d12dad4054b0770a4436ca20ee13ac872f8f5ace7ed525efec9bc"
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
