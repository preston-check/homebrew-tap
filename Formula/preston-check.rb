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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.347/preston-check-1.8.347.tar.gz"
  sha256 "adcfd2091c42fbfbb33ac786f2e317b25136f01fb96c44da02b09e626e35fc28"
  license "Apache-2.0"
  version "1.8.347"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.347"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78fa12c64a73e0d97c60c0c00319aadf16e5b6d2652845dbbec79ecf6838cdf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00917e63b01ed22d993e73f36b3267d67645b653456ae84536dd60391e27feed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a83512b81ff629a6d8f13ef842c78021555e47a39a1dec337a05cc8d8397a9f"
    sha256 cellar: :any_skip_relocation, sequoia:       "dea7f9fa6af6582e727de72ae47bd0a09fc3a67c46b765991889e75096f5dbb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b2053043a81c2149097ba9cd6917ff96e578c73cb1347c3642fec5571b047a1"
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
