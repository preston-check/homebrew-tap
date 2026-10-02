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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.515/preston-check-1.8.515.tar.gz"
  sha256 "7fe4bc56ad2a19d16495ea7fc7462327456ebaf6776115e121e18e14dce806ae"
  license "Apache-2.0"
  version "1.8.515"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.515"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c19f3f86ec5a0c0f4d05e882ba1970f86b6ab35a708d76c4ff21d95b4323fef9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74e4baee940bfc33ac67c165ae2d6622c1dd9a6362ac23501119fc22101676d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e33ab9cad99a57ca733255e8998b143a3a7e118695982099e957cb2e5d67f6b"
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
