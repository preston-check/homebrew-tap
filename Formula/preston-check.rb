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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.77/preston-check-1.8.77.tar.gz"
  sha256 "fdf8302a676930c09dc34f0bda63a792aa3941f0963099db1457487bb46431a9"
  license "Apache-2.0"
  version "1.8.77"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.77"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdd3b49cac354d2c0084c69d7a355b3517954a9c8c9baaa0c83baec7601d1d97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e6d7da426ca1a2a6330298c0a3a126878fad7df7636f24331b9f41047386fc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bed6a8a79071849534ef4ccbf26da2917b55e871b8483f94b7cc15be4e1386fd"
    sha256 cellar: :any_skip_relocation, sequoia:       "b1ea904780af55d224fcabcdb469838b0ff9568ea5268e83535ccc5a09e61e4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bb5e5eb3775f3011d5d2fd578d8926d6534b5f5e1ac082a3d9661d41488c56e"
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
