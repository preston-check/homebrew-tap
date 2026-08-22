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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.371/preston-check-1.8.371.tar.gz"
  sha256 "bfe90c492cc7ac183383093ba03821c2d551150dfc50f20fee368e636f30ced8"
  license "Apache-2.0"
  version "1.8.371"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.371"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96937d091fb1e1dfd8365bd30204808b098c65db81f085d59fd2ef7dc6f7902e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6160eb1b9fa00dcfe6064234b7974578086f66c8b9fc8815d66b7573a95e2010"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a852a221368f200e60a04a863f1ae92f404e5339d4503ab50c8b689de21e4d87"
    sha256 cellar: :any_skip_relocation, sequoia:       "175f90dc4d2dd1da46772bf4239f0d681edd0140b66b57d044f40ef0704131a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a48af50ea25e26c752ec615f467021a6dc4637214807bba4dfa62a608f139df1"
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
