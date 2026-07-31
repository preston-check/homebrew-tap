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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.167/preston-check-1.8.167.tar.gz"
  sha256 "7e5d7802cf697b38aff439f2fede482a417b873af7faf0b9d64c4b78d10254f1"
  license "Apache-2.0"
  version "1.8.167"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.167"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "129ba888b465a52230cec29fdeed2001037ea4a2967f9c9fbdae9fa287435782"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "896578d0483dc652c511c0dd96012a29d4cfbd1be8765391d9c7f5c278cd0e8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2ac8bac0d109c300527ce97f1a6e5c0826339337988246926765441b160447a"
    sha256 cellar: :any_skip_relocation, sequoia:       "8f7a3e79e7ca2e0a39650237857239cceaa605a2c2494ea01106e26d241cbb7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41c7d3aab8d749b1a50566087cbe646b1d2f5193a2b506006338bb387b058e13"
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
