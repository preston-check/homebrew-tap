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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.149/preston-check-1.8.149.tar.gz"
  sha256 "5c77e25cfcf059ad0ca182c0eb6f4c725cb0023fa7271490245d247a9222442b"
  license "Apache-2.0"
  version "1.8.149"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.149"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb7f811b99a3656ad868dcfede11d6912ee76645771a3a390c28c760c1a44440"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24774a3d5412506cea53566d7d9639e52bb20044c3e699bc411bfe0f0f08cae2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56f8c36b506f74346b0db72ca41bb79a904ec85f657dab724d5acf036a20ec4e"
    sha256 cellar: :any_skip_relocation, sequoia:       "80e853bf27291cd23336469709d68b11c76c6afd4eb1c5d7eac9cafe27fa746c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e786291ea47e29214c1c64ff38e821a917db7816364c692c243ba45dc603fc8c"
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
