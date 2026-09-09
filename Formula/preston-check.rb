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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.436/preston-check-1.8.436.tar.gz"
  sha256 "475f03fd32047b3dad0dbdfa5840ab2932f0f918c89763a028d544557cabecbe"
  license "Apache-2.0"
  version "1.8.436"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.436"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23076c9fb18437c7f296195ee442e7a0703c2d918454a3ab0b1251228394c6a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c82a76b91bf6cff9d457c3975e1eb75aadc6dacf7eae64cc4fafc06bf555543f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e31a2803ba7a8a2f2e5f0a1940f524f9046f0c1cb94acefeedc92815aaaa4445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb230ae78cc24a19f37f0bb22c9adc2c8df6fd32d7d02e7b847a5562668ee4d5"
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
