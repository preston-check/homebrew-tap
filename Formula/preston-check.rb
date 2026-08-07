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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.235/preston-check-1.8.235.tar.gz"
  sha256 "e4da42ff9b8a718bf6701814d33453763894840a20f74fb372c2f4925ed90e2c"
  license "Apache-2.0"
  version "1.8.235"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.235"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82c7c9b0d5aa18bf6449a4ea7c6f0621680c8329be4d98a2ee1b77b177db80e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fec2f6a2107146bfffa4150f16ef11a1de15d5cf79963c979f1c791b44c2b4dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da91fa24656aafab6cb09b05cde8ecc4b58c85423506687f8c2eb00e5341c0c1"
    sha256 cellar: :any_skip_relocation, sequoia:       "51e9b0b045e67e831130b72ba4d8c01c37eedbcc546c1dc95215c22f32599925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f2a93343bb251cf76a1f9c7b6bf639fad6b9fa016bf87d018f3db4b8315a7cf"
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
