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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.210/preston-check-1.8.210.tar.gz"
  sha256 "a3eb28dee2c2b8d02b719fb52450ecd4519346c2d6971d5b4a132c5fc185d734"
  license "Apache-2.0"
  version "1.8.210"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.210"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fea3da285277d88c1f19e57ec65c132707990f0712d38d98c0eee7d52096810"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac28ce008316facddd2c6063883cc9d09da06c5c50663502b2785ed1d9a07dc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29acdb792c26d10c19f4978caf0b0aecf3bb6bb936a1b5d3eed75867d175dc25"
    sha256 cellar: :any_skip_relocation, sequoia:       "82d32ce2268a53b05f1c1ecdcf92b5cce6e15263ea9ade57c53fed0bd7c5d1fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a43cff9bd8c6e573b0ccd081be9cd4b31b34fe91f864dcb0555dc0a4bf86dbf7"
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
