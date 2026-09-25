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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.498/preston-check-1.8.498.tar.gz"
  sha256 "197bd7474153be82ff16027a873cfdd09e463a75f462183a1a0c8d45dfb99768"
  license "Apache-2.0"
  version "1.8.498"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.498"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a58179e392c16ea93c853e5cb90c3963352818b0481a47151dd97a007e8df2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b1b5fc98f55d482bbcbc1bb2bd266463013bbde73a47e239c1f3c00d080caaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8492b8bf7d4e94dd4a2b380c5637839088711a740c9c0591a3536327ba91692e"
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
