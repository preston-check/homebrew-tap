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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.530/preston-check-1.8.530.tar.gz"
  sha256 "b9e67b7dbbfd6de4f86a3e098209c0339ea875f86da805326a0b14298ca45955"
  license "Apache-2.0"
  version "1.8.530"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.530"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bd69b26c3cf9e0bc3b7cfafbb114a67552ac6dab388957ab24c4c82358760df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "800ae5df112b4f253e60d937ac495ce1b733edb50b25c130a7cdb392d2178a4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ace7535fa592963c58b21ea4347ab776ac861c32f3a25e96946a82a97c271a46"
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
