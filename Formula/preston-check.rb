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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.293/preston-check-1.8.293.tar.gz"
  sha256 "714cc12314de1cdc774e83d36cb4124a571087277a2309ae367456c04f4ec799"
  license "Apache-2.0"
  version "1.8.293"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.293"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30fabe1e71a352b59b33a8c57a566f4d6ad0aab7b683d51c0c33b605b11062ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abc863b6208d8f4560010ab0be5e3ae077ad92994c7d085315c175a4d2a88e7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac0eee9c9a3c89862c5ecaef7d56b1e1def84250e05475b0058135a5e348ecbc"
    sha256 cellar: :any_skip_relocation, sequoia:       "38e5c31fd17bb1170ef2d491155d786251d942d032a170f63e4145502abe7824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b539f5d7d5566e438b7e64dda260d99860c67c1571bf70fbd9071c7e45b0f5f"
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
