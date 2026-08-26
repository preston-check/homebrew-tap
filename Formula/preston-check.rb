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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.400/preston-check-1.8.400.tar.gz"
  sha256 "a8d2ab216d4cbaeceabf819f44f0cfae80fed3dc39891a6d8e8d6b8af4cd5fdc"
  license "Apache-2.0"
  version "1.8.400"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.400"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5a53a6b788e8c41ddc3a35397977cc556a37f4159fb4f8e9e07237f28f53c4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bdeffeb2bf5972ef30878d22514f9c291fcccbb0b5a3f4639d1ee549a19b348"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ecaf402c145fb809f0c1d081287ace35cad5c2f87c007786922e0dc55923b9a"
    sha256 cellar: :any_skip_relocation, sequoia:       "52709ca55fb489c0b21aa535763439c44b90f7bb68ffe37e4cd4eb7004992fc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39b4877d9c13a3e14abd7f0b05b0d19b1b81e5d18868987f3452c5115c5f0c9e"
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
