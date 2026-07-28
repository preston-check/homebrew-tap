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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.135/preston-check-1.8.135.tar.gz"
  sha256 "957b402f88d65e08ea3c13b0094481119313bff9760702cced1836ed52307cb4"
  license "Apache-2.0"
  version "1.8.135"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.135"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6586b9499e2bda9830cf5b6c6904e7ed659abd76e10d7a225f2769e6eeaad9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89cd739fbada096d522350bde941f3b7c06677239ef92e12aa72fa95c99cb32c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba6f5df5c1d92ab172112975eec52dc1c494ee08eeecec3e58ed0d3ca6230af1"
    sha256 cellar: :any_skip_relocation, sequoia:       "eb319423e316a5596a7d6e1f3841456a196a16cb25c6314e60abcebc5581c179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53f88de6b4bf606899f6d0383f2ecb99b0c509d6bcac474686ab028512be9118"
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
