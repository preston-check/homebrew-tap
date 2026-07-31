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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.168/preston-check-1.8.168.tar.gz"
  sha256 "8d8f765a21ab49faec524a13d3da260a7955c719242719a4a4753b10352503a6"
  license "Apache-2.0"
  version "1.8.168"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.168"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e28ddce246a7e662ca288b80f3d3ca4935624f2af57d26e4ed66f64afea12b06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbf7f714e49c6b3d67f0fc766cf63fa80a5d9ce002fb6cf4d3ad323d5ab25726"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2716733b0d33b43946b7d69945039c8097cfae1ebe778d04450ae40bf85d9abb"
    sha256 cellar: :any_skip_relocation, sequoia:       "351f958f9162e0f6b8981cdf009fde1bf91ecfdc587d55a10e18d0b946944438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25a00eec5b1eaddd41d9d91ebec1ce9d7490d8c8e2ae3f995ee93fde5022f01b"
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
