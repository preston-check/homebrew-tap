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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.547/preston-check-1.8.547.tar.gz"
  sha256 "f9a34717519dd28b218de5e9e9b4dd21712726edcd35ab9ca93c8585cd5865ee"
  license "Apache-2.0"
  version "1.8.547"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.547"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6ab354f8aa3cf144e173f0c340a5ae64edcc7e384266f090d1781c5642a412a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e5947d8d45c6edcbdbbd238715686277f50b07f5bd66468e8b8dae47107739a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe7ebfbc7a8659c2c88291a1708acdad51b7d35307aa3129ad1feeeed62b9245"
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
