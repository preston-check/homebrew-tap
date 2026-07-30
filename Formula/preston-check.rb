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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.159/preston-check-1.8.159.tar.gz"
  sha256 "88a930f380e3748faf346e734f738e6bcd2d04ef74e0a2d59da5ec5311558250"
  license "Apache-2.0"
  version "1.8.159"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.159"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfcda0aadf598b9e493d5c8d5e9922da8eb48f4f1f7b58eabfd3f38218b62415"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd96fea104438b70c764f97eff17d75cfad570863ce2a2dcf19df264aca6cab1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a82422074cd4eba04789f859f6218c73270f6dfb10103b707f17529d90aeff4"
    sha256 cellar: :any_skip_relocation, sequoia:       "55df0901135b59cddc9139eb9cca53acf95e144c0357e2cde6f1f3828c723f82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e56b774b86860421e96c113a87572d00e9df18514deecba246e5cf50446e6f2a"
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
