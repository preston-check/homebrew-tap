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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.432/preston-check-1.8.432.tar.gz"
  sha256 "1edaa7297a1ab3ff1bdb488acdb488944656c1f57ebc94f1072f778decd580da"
  license "Apache-2.0"
  version "1.8.432"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.432"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47298cca63f16f2d99ffa69a59f223cc15c608c7d9a2204d691fbce9f7cf9760"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ee5e4bf228e9895b930af0bcfea6147246eb14776ea18ff357f5bb2814c93cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f796b7334afa41fa64ea54a5c8f2a458ed77d3a70b312be59293fe9874b77348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4660ecb235b6ed49e9e9a4078680293c4cf3c11d2d2fbb749b5f08202263cc86"
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
