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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.186/preston-check-1.8.186.tar.gz"
  sha256 "bfe7f24ee1182fd0b675a71927ffadb691da2a501bc30fdca25c5524a35f3c61"
  license "Apache-2.0"
  version "1.8.186"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.186"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "becbaaa0017b80716efb7f15f3fc91fb560f685411b5c1587ffbc743e684795b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea33379064ba9370d3cb1c6c84165e140075300bd1cf96c3e83f3a4c367685ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d85a58f4ed09db9be68ac1912f580e65e26b7befd93c7066603fcb7d4474caf"
    sha256 cellar: :any_skip_relocation, sequoia:       "74a3edaba18cb45c588fb9d405a4c96f893eb92b80ec94c12843f09942864c08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "645a7fb5e81e806651b9779679859121b6189dae79868e4412c25c26b9b2b17a"
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
