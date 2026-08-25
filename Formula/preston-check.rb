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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.391/preston-check-1.8.391.tar.gz"
  sha256 "2c80d114f26b565ba1873ba9fc896c7464966a08fde0cb07d37d69d6051e2bb4"
  license "Apache-2.0"
  version "1.8.391"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.391"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "298f07a366a379123ebee87d48bbd187973333d899ea43ec52c51610389cb867"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91be1700e8ca38811d711079f581b669f8dbc2c7a6f3c794a88cd4bdbf6a2cf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a10d7b2219b2e639fe01870999634bd9e64259363b1fea97039dba63603c0d4"
    sha256 cellar: :any_skip_relocation, sequoia:       "caee1864d063e9ab41b1895abe81abed78c46dc34e4c145f69d995f342387976"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ef50023e8d07e575c345964db1c1550e78c9518f736d43e9302bee79fe46264"
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
