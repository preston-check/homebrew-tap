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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.173/preston-check-1.8.173.tar.gz"
  sha256 "4fef2d0c7709e99bd106e520bbbc929793ee780f2c5270ab5060db6fab9ecf8b"
  license "Apache-2.0"
  version "1.8.173"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.173"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7d510970e546d13959369e37c47202783f5bb70ea3b7a1a31431b23a7ccac0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2d76848b830d9f01088e07e1b6fb2188d04f85918a73e4302af6dccfeba3b37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7782d0bef044ca83036e6f15b6668c3ee931f459d965f7f663a7899ac555cff6"
    sha256 cellar: :any_skip_relocation, sequoia:       "26f4879e700a5587c5ded7e87e85224bec6f3e7bc8da975473c69dbc6b1f087e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cdca98af9d28d5ce86945afc74d4c08ac83db68ba9578e39c81c41eac50f0cd"
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
