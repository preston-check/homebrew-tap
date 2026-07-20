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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.71/preston-check-1.8.71.tar.gz"
  sha256 "fd0d3123baadd7011369a03d86e86697b56ea0f44ed5194ab88082943a336a83"
  license "Apache-2.0"
  version "1.8.71"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.71"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b64123a14605f86e617e2bbc7d5894dfe3599e622044a29fe8bcf94ba5a1aeb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64e18dcbd3c2cd0c0a03eeabc6893a99cf2a6cb475d8258afec25c2d2b76bb86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c20d409f125ca46a97265ddbcf9991bc29d6f615fab336530f2151e67476e8a"
    sha256 cellar: :any_skip_relocation, sequoia:       "d5b1a55b2830aa3556715d38b5f79c0c765abfe8be8688176731cc12ab223378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99c559ed03bdad4246801feabd08c465584cb6531a1a29bd83840ee6a64b762d"
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
