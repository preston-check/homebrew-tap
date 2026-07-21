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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.74/preston-check-1.8.74.tar.gz"
  sha256 "91e0762a3f541e8d39465e497ed64d2d723023dab2afecdc857eb1133ea56b34"
  license "Apache-2.0"
  version "1.8.74"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.74"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2799ce8dbc3e33db727a8617a7492c51cf0115b21eb5590e07be18c4cde958f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "073246fd60207022715ee31ede1bbc4c494f587a9f530390fd35d57f653b936f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b01ad92c8e40d3cfbaba33bb708c3efe067a87cafe67d10b547b1fb89618633"
    sha256 cellar: :any_skip_relocation, sequoia:       "4ea1ada99fb3bd5894331de40b739381d3a54174f20a9960ed6db5f63fedf311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03b475c8c2f9d2ef1557c1f365fa0c1ee13d746e2bee83349dfa6f7b04f53c67"
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
