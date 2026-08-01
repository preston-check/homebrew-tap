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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.179/preston-check-1.8.179.tar.gz"
  sha256 "ef2ad2d40fc117b1497fcad874dac4e53278560fe7539fc92d179b07bbd675a5"
  license "Apache-2.0"
  version "1.8.179"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.179"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "055cae356ca481b02ef4a2a16c0b9bfff618dfabc41b1849f249336ea178a389"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1cac4a9bd31d0eeb3adfd7d1582d6d28263bc92a37e4aea136cdd4b4a02a2c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bad2f4cf0b328696d9c84e56858c727f76213a5a5dcdb60269d0987cf0fed08"
    sha256 cellar: :any_skip_relocation, sequoia:       "1c1f3c7325cfcf02fea26fb4e0631b2ece38a47f05340c499f73935b08d63792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5dcc50604bec84fffa08932b8c7b957981ffee7bad8ad88392b0120d7da3d87"
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
