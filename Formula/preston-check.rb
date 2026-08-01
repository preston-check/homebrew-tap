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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.185/preston-check-1.8.185.tar.gz"
  sha256 "3b6fd8c1a87a0081a8f307a66f1ef83866851718c7e22842edd76cab97460a28"
  license "Apache-2.0"
  version "1.8.185"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.185"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcf3ea7c6bd6ec22fe690bbe68ff1dfe94ee294c9df0026c98f25dfb9d935dd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87c2c43aab331a78cfe32f464e0278656500ac0aa36598525fbe803723cdea60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "546f5e6b6d123c2a17b6127efeadfd061a378bb2a3f1922f4574755b48dc382e"
    sha256 cellar: :any_skip_relocation, sequoia:       "ce76cefb90c23a60c651d650231f2cb493c4ad0fda0aaff3e0e9f44e7f52f765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8e56fdf138618d80cdfa15582222701fad560563eabcafa5a1711d1c768379d"
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
