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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.100/preston-check-1.8.100.tar.gz"
  sha256 "ee5709a8e6e67244dd3a66f757ce6611fd97d10f6f1af7d7a220bfe26fff52af"
  license "Apache-2.0"
  version "1.8.100"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.100"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac237cff0d1f99d7ea59e1fd977dce34ecdb8a2b1e6f65e8b9d73105dc634699"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02767cb4052c62d2de8bb4625cb14cedaf50913877f824550b8db7c6f5b00aa2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8f042d7d61742c0563320e6efdd275e4e2ff51a3f83edd9b2b25195915cb782"
    sha256 cellar: :any_skip_relocation, sequoia:       "2e21458bd6ea09a3e11c1a1b548a77f73edf3c799cd71f52f866e0b4d97b6b66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e1b0cf48e6634477819b7e6b6cf933125d0416873c43671ca468951bdf405f9"
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
