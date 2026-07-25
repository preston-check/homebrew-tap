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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.101/preston-check-1.8.101.tar.gz"
  sha256 "3d0d18b40ab4e5e92ac5a4ea40001a06d59b9927ac2a6a4d50e9d3077c90ee08"
  license "Apache-2.0"
  version "1.8.101"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.101"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10e58139b7882b919ba17850c0c701d605569928ea39b4f5ebb90d209c8bb64e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a02ee9a3368f70402687ae127451fc657391edd7ecbcfa0e07ec9afbb1ecc89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10c12b7b7bb00606364d627ec3e766859418e776177ac55ce0d8eb9015c7c00d"
    sha256 cellar: :any_skip_relocation, sequoia:       "f88574e6a19608b21ac9812fad072ab1df6cdb67c323cfbfaeda5ae153be262d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef39bac45b5ebe3e17d0e66c3ae5744b2704abf7a63a88aba73d8be856a87d53"
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
