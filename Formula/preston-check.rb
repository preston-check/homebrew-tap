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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.438/preston-check-1.8.438.tar.gz"
  sha256 "e7d4d9de4d11d58e883395adaef2573cd61efcf04491c86a91dc3afdf6ebda28"
  license "Apache-2.0"
  version "1.8.438"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.438"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23f39b3bad494f4559e506ae83164334d6f6bdf07fded7a4b3ed7f8cff9e8c91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20bfd3a805c4f3e9b643b5f87d8b477e65d1a29b4846075c2de4cc4d2f3cc831"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33f496964f8f37297719c6eb5a8b96a1171e379fcb65cdf4898480d75b65b4f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af44cf6b103b0e555e157514cb2fac5f45cf22ee00f7d26061851291d74af944"
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
