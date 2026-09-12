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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.449/preston-check-1.8.449.tar.gz"
  sha256 "9e07467decb7802ccac30b4e5eb37a24263b82235a64f263455b07eab6e918d1"
  license "Apache-2.0"
  version "1.8.449"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.449"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f7b66b1d83603e1bf7e252f7257df299ee07bde4b442762d7fd49365633366e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53e39e9667cdecb76c5b27f21dc2c3511043f46361949dc9809fddc293054e5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10e2e72556bc1d5a7c96c7c4bb9a0983114f24d8882847d54c2b0ce49b585cca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b74d2bf919bbf271b3655ead8e7526bae77ebf1e6d5d7d23d8cc3a3d7a5845f"
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
