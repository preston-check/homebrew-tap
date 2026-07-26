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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.111/preston-check-1.8.111.tar.gz"
  sha256 "6e3e44b885e4e60850a3a8f7f6628994fd4ea26619cabe5702f84026e788b9d8"
  license "Apache-2.0"
  version "1.8.111"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.111"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c01f23e549536ffdfec260d8120a52be82de43265f5d9dd5bc1f453cb4a19956"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a353b5f12548e1b31064d439ddb49747031a2a5f0a008f8a5decbc020f61899b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bf47ab79881be7208e0ad4aa5177dbe883022e2b4a867bcc53dc93c2ba086c1"
    sha256 cellar: :any_skip_relocation, sequoia:       "e6fdf501494f0e01abc3b9b71083dbba8f438f55e6edbe94afd52af877baefb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "107ee4cb7abbc195bd8f0359c73dcd98bf54f71a77f6c3dc9bd913f9bc43998a"
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
