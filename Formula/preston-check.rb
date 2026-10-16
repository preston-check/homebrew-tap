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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.554/preston-check-1.8.554.tar.gz"
  sha256 "ff4c1b9758ab86a6ac0d0ecfb587c8af8b687138ac141f3995a96a1497e9a059"
  license "Apache-2.0"
  version "1.8.554"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.554"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6a4b2498f6aaa7097e725d90da23adc3504b527559588f12d5641919712dd98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13529a2f6f43adb92913146a92d604bd7328d93d161711e62ca43263dff54489"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12de822556da7a1be7a7de9678c8344225205deae351b14be7b30df23f96f759"
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
