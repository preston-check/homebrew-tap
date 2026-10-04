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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.523/preston-check-1.8.523.tar.gz"
  sha256 "fca3a58bec03caa1d34b8e44639cfe508fa47179a246b40f322256c02f7bc6f1"
  license "Apache-2.0"
  version "1.8.523"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.523"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38f781c7977f9eba652b40e110c2dd59550736c5137c4c294673c20c1c38e405"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5638e3848fd41394108c59ea2230d6c0e0aa13e77a264e7481cbd551779ca931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ae93649573c46542ffd1082f8765fe2d06477c1983e7cbf0551d50b95b5c3a0"
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
