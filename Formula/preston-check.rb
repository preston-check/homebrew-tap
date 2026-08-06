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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.232/preston-check-1.8.232.tar.gz"
  sha256 "692efc1a483106f3b02c9bff75a523961cdf8dacb25bf472dfa102602eff7e29"
  license "Apache-2.0"
  version "1.8.232"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.232"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bdd78f04afbcca85338dcb9e724db3fb92068f0a3b8d5bc7eb34efcb4345571"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "180bd3abef10efd950797fa3ed4ea2db16120116d5634b9c0e24b82981297179"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31539b17ee2ff5e3e6ece6e3036f2205908bc95eee5d12029bff97d3c06b235e"
    sha256 cellar: :any_skip_relocation, sequoia:       "6d09cc199d4dad8d2295bc3f555dd6d93ef553c4b7bb2c96268755ac80983c13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "133b4aa8b6bba472f1ec01bc11fb1cdf3195fcf8e48d5f29350244aba145d5cc"
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
