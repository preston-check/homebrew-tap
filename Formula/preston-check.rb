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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.47/preston-check-1.8.47.tar.gz"
  sha256 "a4ac50edb7b5dc48bec06c2e73648d4ce308fa69432d8d8e2b773bd8ee3ac3c8"
  license "Apache-2.0"
  version "1.8.47"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.47"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8b59143a7f6ef56bc8cc0e5b3e73da551fbd35ecb32ec531fc453cd77a34e7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e481b8d4b03e0c22faab56e2ff8211aaa118a3ee6672284efa10ce0547c2a804"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78ea35c8f4feba132e2415b1862ad5f6d0067929e49a069e39f6d979b4d69f21"
    sha256 cellar: :any_skip_relocation, sequoia:       "57c83c6e4e12457d7d860e3b577ed2728c57eb8068ff3eb8f0361e8b7d1f1ef7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1febc9262eaefa2643c77b7df430a029bb5d22836b2c633f1fef9ddce1afcf49"
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
