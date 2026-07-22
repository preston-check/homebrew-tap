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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.85/preston-check-1.8.85.tar.gz"
  sha256 "5bcd9931c563cfe46f69b6f3ca83bec6bcc4201d4fa2f1cde560145982bbafa3"
  license "Apache-2.0"
  version "1.8.85"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.85"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c23ad27a6ebf8482454b779cb68fd6392353e90de17c2d5815a618c6eb06fccc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c883be46517a7f9e0b96caf2a10790e612c949a034bd6edebda6828847ad02b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c51d7ea0e860209d690dfc087b9605f86551523992e1a89e6c73a6f4fa72c85d"
    sha256 cellar: :any_skip_relocation, sequoia:       "cfea9cc610cb633e17f5d22962ff03c6c2361640ccf09fe95971c8c4ab5fe5d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35938f23d918f5a4269e1a7ad99d8540763b6c4bc16901b175726da290dc073a"
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
