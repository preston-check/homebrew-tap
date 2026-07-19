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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.60/preston-check-1.8.60.tar.gz"
  sha256 "24945ab2eb7d2c485c7308ca2cf9f72c959469f76f8e708144a3fbe260ab3925"
  license "Apache-2.0"
  version "1.8.60"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.60"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d30e022607746653b1d968008b98549148ec2fcb91596cbadce5d846c9a80960"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5e7ebcbe495a8626d44683bf72d13ae9e6d9913b2d12d2f125c03ec6afc86b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52ec2738ca2d66ea1564619378f87922e6a9f6a30b391943a41ab9612ccc3cf2"
    sha256 cellar: :any_skip_relocation, sequoia:       "b7da392e9405a3d1d8bf8004a9f4ba54faaacb679cb0caf429fdb1462f21ff36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c47f21092c64ba4646ea76e39f6546eba0fdad7c2144012fa1111087c6e9eec"
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
