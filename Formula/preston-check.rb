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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.29/preston-check-1.8.29.tar.gz"
  sha256 "f37e74d9d956ad6053f19babe1f8cc345b113bcaa37a7b36c2070b7dd9ea1431"
  license "Apache-2.0"
  version "1.8.29"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.29"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10cf1fa9977fedf6c617c7632241282d73738f041d4b1dee8bef4d1540f33d4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66d33346a22fad7183f266171c714331c3fa2c24d15b6c9067d9cd132a96e6fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45ff07364481fed4e102c26e47cbf7dab25d5b5037374e1b80ac64086f222ca2"
    sha256 cellar: :any_skip_relocation, sequoia:       "6d02d3591dab46882af301bc45ed678e977efb0f2c827091530b18f16d6dae7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f1a2925c0402575efb868c25af74fd4ca902737a92a3ef37bea6b918f6b4463"
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
