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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.285/preston-check-1.8.285.tar.gz"
  sha256 "8d8d2b57958a20fa98e82f030013160ebeb6acc2273869e8a21baf1ac21fd4fd"
  license "Apache-2.0"
  version "1.8.285"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.285"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01b075e00327f0f4711cbbe8586215e97737b2a686e297a55cf6fece165a1c70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b7a8c4663c41e27c7f9aaeb5c7bc4bd0701928f00c515d127a041aa579fa0a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "091fc9ddf88e4a629eee0349fb8a8e7583fe62d587d2cd3c5c91e43f5b997f96"
    sha256 cellar: :any_skip_relocation, sequoia:       "2f7816f4ac6f3db0da50e11539626b136a7830574f2cf6d627e644625c05492e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96af2d3373e644624757eaa215d3ed89da85ff7a09f6937e5aa6fbb02f2e081e"
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
