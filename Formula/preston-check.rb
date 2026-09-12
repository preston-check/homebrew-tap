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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.451/preston-check-1.8.451.tar.gz"
  sha256 "42f612dfaef3074a44e886dca02a5e80ad0286ba7c33fb382e1894c886a04298"
  license "Apache-2.0"
  version "1.8.451"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.451"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "028dd15bc64d4f49b0ab04e5697e12f94a869a6651319af7d5324b3fdd07f461"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e261a04b947c6354f14feeb1f371ab9d1a182d1446d01df7cbdd42db1741d95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a1cf741b2c5fa6d0ebeb10bdb7443b8124015c57585732a803e0063dc70673a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d420bd68cba1997d3c3ab227085cd08f8f4d527e37e1d5f2049c1fab62533060"
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
