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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.396/preston-check-1.8.396.tar.gz"
  sha256 "75d2b6ffcedc03f8e4c89903380a3b4c1bff0d110543fd6fcb039ce4f4ebb8d0"
  license "Apache-2.0"
  version "1.8.396"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.396"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f859929538adc850e37625a7f27158fb13a49f803b006fff48d6d47319a3eaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b54ea184c74a19432aa4f21fe548db57a6d4daa3d5d9198dd151349fd0ad9e5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66d7aee9127e620e662c1bc4c30a3c3b443e7342001408970fbe2d65871d2370"
    sha256 cellar: :any_skip_relocation, sequoia:       "414381248a1a20c832cb1f3fe9375e7838a355dc251518a5bb170de19c3b8742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc6e1a50e75b85c3e004729f3a2523fe5fc04ac5c57bda584662a02e8098ff7a"
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
