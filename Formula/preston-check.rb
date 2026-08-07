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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.248/preston-check-1.8.248.tar.gz"
  sha256 "a8efaf6e1b1041f8793f9ab3899d81c59d806a51914c47148c746c004d02630a"
  license "Apache-2.0"
  version "1.8.248"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.248"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caf2e9db75b566389fab4fb1c82918de0d796826a28a90158b2a6a0ee0395c5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9637a385a520e1e98f5863d34a1c954051604f3b804c5d817bd687512fce48a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "360cc035af656aa4bcd2370d5364285d196dd4814ebaa4e73b26b979bc3a0e5d"
    sha256 cellar: :any_skip_relocation, sequoia:       "87e68bf32f137ce617f02741ce5518d525fe99a8fbf1dcc51064889e7e4fe5b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57a866c8879e9e05835d1e0620972b2a8f383b956a6baead65a08c7277643b3c"
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
