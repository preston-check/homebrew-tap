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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.163/preston-check-1.8.163.tar.gz"
  sha256 "b5d36b9c017cacd1e3b44e8ee6208447fc55019501f580f187b6c0a6acadd76a"
  license "Apache-2.0"
  version "1.8.163"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.163"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78232f17755f9bd67e572584f8ba79fa090c4b2208457f8495c89bb067fda7f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "182159a7bbeb7e2d2dd34e8e4e92092e8872bb558c6099e6cae0e9ddb3823d73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85a685f27b81d510fde98ec0e802924e18a5166939045ec8b024a9beb65b0015"
    sha256 cellar: :any_skip_relocation, sequoia:       "ac246184918487534866f09bc7972392722bbda5cf5b394531c2643fea4aed27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc2a9c16a56108d515ce9fb19991c3c16395aed89aeffe19603efc71350ca7f6"
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
