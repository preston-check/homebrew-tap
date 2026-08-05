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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.225/preston-check-1.8.225.tar.gz"
  sha256 "246a651e99d64d2d192cba888d20399a9d0e4303fa862bc5ab98ce7615f9fcc7"
  license "Apache-2.0"
  version "1.8.225"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.225"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82c212e99ca3705455ecf26595d6fb1dc80cae546f6613138ccacfca39f13248"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f57ed1b4d05f020fe90cb4387faea79b81b7980d4898727aaa1c61af57c72ab4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06e8ad04729a838276a226fb43461f60d20cfdf4d646fe145f2af860c537536e"
    sha256 cellar: :any_skip_relocation, sequoia:       "a92f16c238b9bb7f18126252a14f4cbc0de0a5b6f7defbc4d8349a905fb7e607"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "909ba8bc1d71727a0e5cc2a540d1103f09b2d8f6431933e116c877781635c1c0"
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
