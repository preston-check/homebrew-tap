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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.292/preston-check-1.8.292.tar.gz"
  sha256 "b76cf418cc5cfc8a5e8f687edaa9d3d0f1e30d93bf06236046cd8c9d7b2d93e7"
  license "Apache-2.0"
  version "1.8.292"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.292"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ef37754ef72f9d569a101d9da82bba0775beebc506d1da1a44f353a19ab59b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b86354daa25d65e471cc24c4150c4a382f00b25ea6466728c7f9e5222a8454ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26d78fcc7e6a566ca2040bb45db68bf86d16477486e34e404782e51b08d07b67"
    sha256 cellar: :any_skip_relocation, sequoia:       "9a780619124bf5851ada0de38d9aa2b386939c1276fce93b01a90ab4832a2b66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a39ee960adc3d37d70f4dcaba5b82b97bc1c92e069e551f8351dba16de11e839"
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
