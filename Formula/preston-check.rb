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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.26/preston-check-1.8.26.tar.gz"
  sha256 "baf95f3c276145bf8af564e36dde890242684343d220cf88f396217787b6f6e8"
  license "Apache-2.0"
  version "1.8.26"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.26"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a76e3db6eb79053d675e436c53cbe0d27758979b43ba6f8660cb145f5eb2536"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d13d652de1f934481a5c5df8f8b8ad1c658f2a4a2447c2ad0708651bdae894af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a43ee44eab5d33b2a58fd15a25c48857342382de09276a5c6a0b10665163b58a"
    sha256 cellar: :any_skip_relocation, sequoia:       "5850c79a40681a5621a7a27df15afa5d27feec1eb4b2e710017b83e398241465"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42fd9ef00a5ba964c797b1958e871e4aa281d2ed6be8414ce8e207b509e57248"
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
