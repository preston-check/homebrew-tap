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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.259/preston-check-1.8.259.tar.gz"
  sha256 "5a2da7d98f3aed6673f86101c8e6412a8243f713ed4ea052d801d74862cdc3e4"
  license "Apache-2.0"
  version "1.8.259"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.259"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00ce6ecd36509fe27c71a9dc542a1e23b4a7ed34a81bd7d681bd4992879a8bcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e005ba018f7014e52f5d5d41fa855972b5a7be428459e0ec0012ad4ba10a83f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b57300476197bb29ac6fad44107b331438e190863269c159550971bec2313335"
    sha256 cellar: :any_skip_relocation, sequoia:       "4e893593f0c381fbbbeae21cb6d2dce3f20147d3e80c5682fe21f6caab34b2ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0abd8b4807b8e66f1f86079fd2bf5fceb0c3cdde12c1270db60cdbbbbb5f927e"
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
