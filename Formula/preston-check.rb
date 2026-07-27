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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.128/preston-check-1.8.128.tar.gz"
  sha256 "751d3f3c3bf1166104673ee50fc1e0081aad557957bceb4053e04fac3c062be6"
  license "Apache-2.0"
  version "1.8.128"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.128"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fa3b6621dfa5f897321e39d42443a4103a05c182c8d874af69e3ae503658153"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bc0a6be3d65dcbd0b3b441c80532118070e501b1dd7f41b02b7606dbb8d042e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ad63fdfa1a06406c61a6a817d90a992910ada1f052c35d96759e18e8f31ff83"
    sha256 cellar: :any_skip_relocation, sequoia:       "6a18669faa1e00e8d22572e293ce54198a0e554efd3ee6d49f4700d117722837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edfefb1f5f28690986b57cbd5a5bf2dd67b4508bfc9d96a89b043438143adfda"
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
