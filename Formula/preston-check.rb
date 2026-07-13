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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.5/preston-check-1.8.5.tar.gz"
  sha256 "706e87649f17b8864e36605d84e24caf64305c4e2a0f9e2c9490a3a2dbe896fa"
  license "Apache-2.0"
  version "1.8.5"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc7fc8bf624273399d1250b10d142d38a64032eeaf4b1a384a6e295fc1abacfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cebb8a4aaa71de591b29535262ad0198804144a065840b578dc3b1965f8114f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8fb0f2c3bf9c4cf076d057bf46f14b796f28afba73c7393a0b69b388f556e56"
    sha256 cellar: :any_skip_relocation, sequoia:       "59435ac7d638590d8d37f35173bd883b02c32365c5d9a76a5c5a7a735789fcd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37cfc38cfc64b5bc2663703927da4d38848f8b7a8eea13cec159425ca1b15e8d"
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
