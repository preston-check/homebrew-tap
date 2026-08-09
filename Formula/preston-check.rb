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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.294/preston-check-1.8.294.tar.gz"
  sha256 "1a8bfad504c7de7cbc691cbeccf5d9c3753674e69e1a6db547bdddda3597e809"
  license "Apache-2.0"
  version "1.8.294"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.294"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8ac277f8037e9567559e5f7f3197a3c6c256ff22730f57e7cc880c6bf302665"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96a40d750772c8a9ef5e6fd547a10a209b17f27df1f9270709c6fc2ffd24e364"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "584c8368483cd774e72e60e35a8b7af79edbe05adb1c50fae295136a1cf599cf"
    sha256 cellar: :any_skip_relocation, sequoia:       "0b13a89beb52d18d00125001d5b4eab76c8ecfc744899c500afb365853a10db5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e0cc452f9c3f660a0d5a00dcea5bfb532fefebbcfc29f6f3b7ae1786fc8e3ac"
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
