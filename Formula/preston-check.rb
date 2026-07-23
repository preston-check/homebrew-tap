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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.89/preston-check-1.8.89.tar.gz"
  sha256 "3392946639cbd04f4c0169ddf03861202221d3d48f72f6e78e8ee87062736fcf"
  license "Apache-2.0"
  version "1.8.89"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.89"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71e3da164b7b6c909c03de80fd5831c26be414b1b8c1f4ca75abf64998925175"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9ab4b9ff274c556c715e995ab5ed3b874768263c932b05e170c567e44ad513f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9038afb38968d86191820fa9e98c53eb700cc610c28a9e29bb3ffd2ccd325e83"
    sha256 cellar: :any_skip_relocation, sequoia:       "0684e3a3a8b020b61b5033a921f578c2a61b3f98ce06dfef9d220cc8b5b731c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ff77963b3eeb1cd51e4a8444750c4a2a0cf3a9e02ef3da933bd3e38583edb11"
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
