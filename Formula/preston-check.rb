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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.268/preston-check-1.8.268.tar.gz"
  sha256 "ce101cd6623162bf3914119f28a95066a1f82e1c5c04662fbde2c23d919d8313"
  license "Apache-2.0"
  version "1.8.268"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.268"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80e18a8bfcd0b95bd86d7e014510cee51ad2cd7716ea854e4da5c875f886424b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff5723071e56ebe92f22cec5cb5ee8e9af8f4da464f5cd5c708596d84db67eaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa41b1af45afecbdc1faf10a04f0ea557d8b05fed4a3c24b585032f12c2759cb"
    sha256 cellar: :any_skip_relocation, sequoia:       "e75cef17c5b2894f41cbf4e9600a4cf6c85dac623e8ed4ff141edc34ee173f38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a7330e5efe708cdf2d735459cb82da04bf2438fb8ccacab7afe5b432271a250"
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
