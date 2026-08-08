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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.267/preston-check-1.8.267.tar.gz"
  sha256 "1679a0095ea5ef15fcd95bdb1fb28df36cf68d6403b1f8993ce422ae596a693f"
  license "Apache-2.0"
  version "1.8.267"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.267"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4de4a53544215ad7aa2c23dab642a73bafc2ab99b317439dcda1fca17bc8c07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e34aea83ecadeb51f943b1316ccb7cc27b91058929a60bedfd663176c6e940a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "877334b80863c6604075cee467f541b132efb85794ceff202e1108106230f3b6"
    sha256 cellar: :any_skip_relocation, sequoia:       "ab3f7a86f20603b464820d7b1e21773ea68e9bfece31f9286b34806c26170071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19119050279174ce3c75bbf684edb63bf3dda47cc62c7c7730fad1486ea77c9b"
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
