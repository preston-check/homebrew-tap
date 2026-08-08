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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.252/preston-check-1.8.252.tar.gz"
  sha256 "60e194af44a6a85121e78ac80a0e45b0af1ba75904a18e8bb2ab9ca061118a26"
  license "Apache-2.0"
  version "1.8.252"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.252"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f009df02ebbd92fadc80da5f5965a771c3ad63585bd4e32ef5c4473ba1e6a4c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "117881cb7a8a740ada020102c39d514d673300d4e18588f0a6c7544c5d0715f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72f2697de4db503507f6405e9656a4f0b0741a85225e4cee72d22d1fec42bba8"
    sha256 cellar: :any_skip_relocation, sequoia:       "71f600b36212f1c7476ce302fbd5dbd5d467d5d65a8f69380d912c6cbab01e55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b0badc9022d0c28cf34e5419f941ca88c9c27694ac0111828e62abd7774235f"
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
