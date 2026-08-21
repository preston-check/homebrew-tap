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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.367/preston-check-1.8.367.tar.gz"
  sha256 "4ace17d9494173894e916d268ea64839df1576a112a69e99730f01f04f368b80"
  license "Apache-2.0"
  version "1.8.367"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.367"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9ed9b6be8c4349b2b636aabf4179886938e63a782240908a75cceb2363c657b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "471e7db6a1a7a32201e6155fcdd042331d1308a26449372c0e5b49f0424ab80a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25107f097e5c0b60d3d15409e6cc7331f932a8f6e1384c2f3d9e56ef71745d5f"
    sha256 cellar: :any_skip_relocation, sequoia:       "d9725d4bfe37c2e4e16d69b8eaa99bee5e71bed7b5155515497dbb8550ef0175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e460001d5c20973ac118b3e832f41876a8aa69bd93055085d7430e0e39959180"
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
