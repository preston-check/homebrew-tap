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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.251/preston-check-1.8.251.tar.gz"
  sha256 "ea8f60561b4a52adb6d3f91f1d2fdca59aacf68e5a5107e3fad9a4f51900cc2c"
  license "Apache-2.0"
  version "1.8.251"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.251"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81b94df695ef55e0a856bf5d2ed16394530ae219401156af69c694cd19366a96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11a0c11271d1486ad6019c12d9862d9b7065a33bfad3977939cc30098be99a36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a211bde3678db2a606f05129987b5db960ac6023ebb0414d0c51bd697638fdda"
    sha256 cellar: :any_skip_relocation, sequoia:       "0a2a0cabca07ce822eac3c4245d7dcd67a27597f2a9d41f798b1b4de4c52f0f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c432a26eff52ea7893d51cf791ddc573ed861c50c9e00649e9ada94f4ec2daaf"
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
