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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.228/preston-check-1.8.228.tar.gz"
  sha256 "68cf378d35744a8f27188f06b168b2ad83482e1afc22832b516e3dbbce4faaa9"
  license "Apache-2.0"
  version "1.8.228"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.228"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dade8a1fe3be4c86363880e13cbd44ed8ab2b70d56f8abc4908dcda5a29b5c0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5187fc2237152ef651c7d6492d9a8874f8774b787fbf2d6954a12a30cdd04a46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf57a44ef8788148d1f59ee110389df94d2a6bc26591cb274e5ba5202493fd0b"
    sha256 cellar: :any_skip_relocation, sequoia:       "7dceb76ebf0eae6fb106ba0f259563f93463a272428ceb17aa0d5952034e18a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "666a6cad8201e3876132e1111b89d75fa63bdfed4faa929a574c8af2bb56de99"
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
