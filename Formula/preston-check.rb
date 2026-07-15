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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.18/preston-check-1.8.18.tar.gz"
  sha256 "dfb1e83f3893d37b5d8bfca2b331274434b4be097df88347a21cdd6affc34067"
  license "Apache-2.0"
  version "1.8.18"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.18"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a16d1713331016c669c81a9a14e16348b15c2fa27ac3307568f84e54bca9f6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0f116aa0f279615e8f4cd379ba77a055eb3e870cc76978276ce41a8ec14a93e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05be21eba193fa6a257b19170b35994073542a9927aa680d5bd88853e0954c6a"
    sha256 cellar: :any_skip_relocation, sequoia:       "4bebe829042da2013a4c889dc826a8f8fb6ac1e24749bbea35ef81c15d0004d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c90c68d435af3df28dd2e435d391d94745d9b26a068e58ac798aa12554a0c347"
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
