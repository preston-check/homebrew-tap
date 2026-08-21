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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.362/preston-check-1.8.362.tar.gz"
  sha256 "c67d558df6bcce625d164f698e6034f5a89dce1583809a856e931983341c6626"
  license "Apache-2.0"
  version "1.8.362"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.362"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a03603e5ec0495b1bca7c2fb1e411d8ca44914b72502f3f2037b8dc77e4b65c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00bc54650f56f592f383f4447b9bad53bb961a917e49a0de87cbfcbfb38e6a3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78915da7199497e742583adf31e2c98732c2edb405c4e0469fc14cc9934697dc"
    sha256 cellar: :any_skip_relocation, sequoia:       "70413e6aa8a5af6298104bffb867a22d40b9e96bd35689d442d31691f942d3e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e873d1f5c00486a307a82604082428ecbe84ba2fe2409d5773cb4f51dca2737"
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
