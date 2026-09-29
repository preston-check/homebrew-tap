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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.505/preston-check-1.8.505.tar.gz"
  sha256 "1a1eb628b30fceb5c263c6394204adbdf24820aed6a7f88fe269d1bcded5231a"
  license "Apache-2.0"
  version "1.8.505"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.505"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d29a4deef6fceaf7da6f4cbabf3e2936dc5e0306ea5c53d7b14a36e183649ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f02ecdbc15440e4e0ddeee1ebc8a9907a52f46ff05c2f950d35a3d9f9a587b4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b0e8c7139a1384c6aab90889682e14cc78023f604dcfb604c72a1f0e52e01e5"
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
