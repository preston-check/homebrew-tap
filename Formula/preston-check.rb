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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.536/preston-check-1.8.536.tar.gz"
  sha256 "958446f0d1f68a71e0106bf9c8ae141a0e943663eb1b5839d97e932f10b067c9"
  license "Apache-2.0"
  version "1.8.536"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.536"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71e61a6aa28cc9c504080a6c19fcfa4335c1c0ed87819e26e78797319b2b6ae5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8859fce555b4e1768d58e33ab3fd6e4bca136178821fcf3b8dddb769a42f39e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80aafe134de0fd2c68e6d92f5028c4736ca1607b7b3e3bb14b5f5d154e9572cb"
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
