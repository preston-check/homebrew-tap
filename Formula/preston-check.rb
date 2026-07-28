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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.138/preston-check-1.8.138.tar.gz"
  sha256 "9c9f1a4a631890efbcf66301bfc70c55d48cabc82fccac497d41baff930b040e"
  license "Apache-2.0"
  version "1.8.138"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.138"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80ed75ab2dff49b9ec95d619903759d12563fb9162568a55ef016821df3dbfdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4396f7cfbef156ec0d0c517e0a559fe1dcc5a854c83b2317c8bf3ed1c20f1e6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "826953008de99fc7ee058ac326d55ba130702fcd84f14b59cf7a7405ccb1ad3f"
    sha256 cellar: :any_skip_relocation, sequoia:       "7d195da8006a3bab952bfcb09c527698ad419a0dc48f354749caf4c344f53145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a24228d8c619fc8f1ac7e45a5d3a55f72a5b4ef6f439f8ca5812e8a3b60aa5e"
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
