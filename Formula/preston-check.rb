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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.348/preston-check-1.8.348.tar.gz"
  sha256 "b473a9e98a3c10d11d100c415666e582fe881bbdc651feb05ddeaff271785540"
  license "Apache-2.0"
  version "1.8.348"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.348"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38f4e2775451e0ee9dd97f2a9b8ce27f478c89872181fd419f239a1a76c5f997"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dea92e4196bc2f9806e52c83e57b5628b4a858f4a30769ef88ee9953b6ea6fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "435fa68c6b12ec91edf172493218ad9e23278377b87dae922304235deeef8808"
    sha256 cellar: :any_skip_relocation, sequoia:       "072fc59d80dcbcaaba462dc68f0489633e820c7e2983f924f82f500932fd8e98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7537083561678c59684a8b396c0a3a91c20a90e54b16c20e3766364d9797efc8"
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
