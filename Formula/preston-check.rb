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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.526/preston-check-1.8.526.tar.gz"
  sha256 "9c759f3731a0132239bc6272ae8987d9617b851c1363c2c31fc6f5ba62352915"
  license "Apache-2.0"
  version "1.8.526"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.526"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b8079d6919e71f6e07aeccf9358c8d0251cfbd2efd119f5d10b5199a8695088"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3db0cad5dcba92c1e19be06ce31766c9716514d7b5059be256d205e8e1b0aa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e743366108f3aa08d38dbade94c49a3e8177abea974a766b445bb71304c618d"
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
