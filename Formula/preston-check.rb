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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.194/preston-check-1.8.194.tar.gz"
  sha256 "431276bc462f6c614b6da2af022bb49039ef1a494bc551e98ccdb2bb4d5a5e14"
  license "Apache-2.0"
  version "1.8.194"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.194"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a25df78f5734eaca6f3635152144a29c3486f9704763183b3716e69bdd6143a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4820e69a374462aaf21b650a19986fcf7ee3ab68b3681780af2ae0ff31472943"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9559003ec21b4bd135b4ef71ad290c5814524b00b63d62c0422ef3f2a1469713"
    sha256 cellar: :any_skip_relocation, sequoia:       "832a3832bf5274b5138cb4741b22a7746762386bb4026e97e415c528d72014a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "825bdd28e211b298aea854ae2d74571ac3f5dc43cb29df04d9460e870e209864"
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
