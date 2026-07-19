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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.62/preston-check-1.8.62.tar.gz"
  sha256 "49c8913d2acbe8a6a1776e3a7de6262453afe1c76c460316554bc7d211f299a6"
  license "Apache-2.0"
  version "1.8.62"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.62"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "968a7aa23563836680b1fb9bf4baff2392ed7b49a2fe561319c735dd4702b981"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a2902968d728e12d7a7fb15ac2e82a1382ecf82335af6453b2a65a0b4ff63a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2611914f57f828144d00ba0f309c34ae7e6f065a4248a77aeba719eaf613f138"
    sha256 cellar: :any_skip_relocation, sequoia:       "4fc70713f7d5605c503a3d7bbe80e38953921d7a28ceebd8f07f5a4e012d6482"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bff252c7dfa8ba5452328fc7ef2aec66f3337b5986d9a03ee37c8fd2b88802bc"
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
