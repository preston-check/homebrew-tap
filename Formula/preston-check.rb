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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.17/preston-check-1.8.17.tar.gz"
  sha256 "b25a0196bccd23cf913b3d5e47229d4518ec182e5247050f30ae7357516ad05c"
  license "Apache-2.0"
  version "1.8.17"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.17"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e2137f32f74c136044970e5d44ad590ce0fbb29879ffd9b24c817b180898c7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "364ab1cf5e4d25de3110408b564a1470e0c01bab1cacf20c28eb318e75423d26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa4a42de05575819fb595bf2e4e941b80d9d10834fda989fc204b5938ccfcc92"
    sha256 cellar: :any_skip_relocation, sequoia:       "9fedd724eb3e01ba671b5d30187ea1c24465f120273368b5e28c08dc4b7b292b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edb3d34a76f74079b38bf5c2afe154444af0b956b9c5de6616f1457adbc94dd6"
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
