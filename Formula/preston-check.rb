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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.10/preston-check-1.8.10.tar.gz"
  sha256 "8541ddf867b8872e73474fe1cf25a0d1b0e3f0d0379967735d26c6db167ea3cf"
  license "Apache-2.0"
  version "1.8.10"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.10"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5db7c3ffd341686baf9179276d3d081e84ebd86102ede14bcec1ddfbb7e6f71f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86250aebcfc1b329336723f04740f40922252370193470363f181810ef7e33c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38a34115085d407fdb57987f0c6c210fcb2fdafdadad529134451b119540b19d"
    sha256 cellar: :any_skip_relocation, sequoia:       "5c087712061cabe8efab23782c688578eecda2490f2addad66f957a01f21129d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d484424b6838c0bb3f3a3cd95008c167981fc1b51055508c2714a9b099fc16de"
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
