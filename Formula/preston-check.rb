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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.9/preston-check-1.8.9.tar.gz"
  sha256 "498e2a3008f014a77bfaa3b0dbab86548c099dd88bfa3fcf287073e583a18aaf"
  license "Apache-2.0"
  version "1.8.9"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caaff5c795bd133fc1d48c8c5e7dac884f3b4868192e1fb7eb8b1e9f650383da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83027c01f491f4976c648c559c35271bceb19493b2c47448647e444c1b3e7afc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d5f8f850d744f44030e19e607b4c2792b59f9243247ebaf51f802ef9cfce496"
    sha256 cellar: :any_skip_relocation, sequoia:       "43980de8b54dd95ec326ade725a75ae8656d7ab9b787fc6282163f702ba84b34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "426d1c4712689f5c4d9cd2f54d7f43a53111d4a82386d6482cbf75863da35879"
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
