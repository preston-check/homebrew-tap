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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.137/preston-check-1.8.137.tar.gz"
  sha256 "e7f4d020d994bba240232015133c22c10a16ec09d7da2536bdbd58171587f3e6"
  license "Apache-2.0"
  version "1.8.137"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.137"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86fa3cfb0b854cfd1af531ede1f0aa03997a761cf31efe49c22577a11b47dbc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7db4feffd1a7b0705daeaceff301ca303e365ad46e69530c0cff5020f54183e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9cc6cb2006f1c877eb970142dd888c6127cc0a8e7d33e029ea79d64981f239b"
    sha256 cellar: :any_skip_relocation, sequoia:       "8a2874356d7dc507dc244bb50afa8034b58efb01264583591a3463fd1f83719a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d766a7b28e4d997ba5f4930117afa5ef3e7f8dd4e05d778a3450d55a72970e88"
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
