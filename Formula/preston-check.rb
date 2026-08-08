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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.263/preston-check-1.8.263.tar.gz"
  sha256 "b4b329fe0d1cc613906e5eb90f016f94227ae9c67a08d05f75cfd80777ed618d"
  license "Apache-2.0"
  version "1.8.263"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.263"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8524291843cd0028974e0d2f2f213155c1e9ade5e6714b55481036bb4e9119bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b97e9831aba8a23d0204ac7e52a4e165dc8a5b2410d32ae87c2a1cb9b5e85ae0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3a8622041699598368f932172c44081cf7374480feaba94e1a9f68ace2e8db6"
    sha256 cellar: :any_skip_relocation, sequoia:       "aa68455e8011a9806808e4265bbf298239b77fe3768fa9fc763e60c9a2fe4556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac176cdc14603023d0f1248d47bf379a6ecf6e708a675a1983bdf087314b0c96"
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
