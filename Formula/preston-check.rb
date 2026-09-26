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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.500/preston-check-1.8.500.tar.gz"
  sha256 "39a6d8aaaf8b610309477f7da103149894d38dfd9d6a2389fa5f89c88b1fcefa"
  license "Apache-2.0"
  version "1.8.500"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.500"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44cce8e5dfbd0a93a3528c362bf58c81cfe700042f578692898f3f90fce64f3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c1bcf537c98e90c1c0105ad0befdbd030c2a2619f0c8f24926aa713906e2115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ec2575fdce2b74406e842cf92c6ccce75bec212b769ae88b6cba5fa45779434"
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
