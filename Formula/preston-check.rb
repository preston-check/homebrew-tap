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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.513/preston-check-1.8.513.tar.gz"
  sha256 "ffb7b281fe5c400bc7d92333712b41191506968c7eab601517feb9af2f4354f6"
  license "Apache-2.0"
  version "1.8.513"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.513"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "587a3ab1bde2d12c4cf602156428f140d6b0d3b2b42f15a26bfea97a88241c80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "511f569b62bf701ba7016e4b8fe20a3c0f930afbe31fa26da6c57caef07ce26b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a1d8c7849ba5e3794e74e41842be03d20e22f9be679656f1a47bb0d5dc9a5d0"
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
