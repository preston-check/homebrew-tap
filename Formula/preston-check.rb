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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.394/preston-check-1.8.394.tar.gz"
  sha256 "3e5a2365daec30268b63a356d489f7e30996ac05fcf6354e2e5ccdf018621c1b"
  license "Apache-2.0"
  version "1.8.394"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.394"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac9de739a0dbdeef9650b6843e9c1870dfca0039078d32f08dd36a4b6845f2a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7987c7a86a8b1ef000a82e1874d57971a4d3c61387319012ec8f2dab8760b68c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fbf0e30d114987a01a24c9e1e4cab3aff3384fd5453ba738095a274813eb9f3"
    sha256 cellar: :any_skip_relocation, sequoia:       "d6c54b5badb47f9d4bdb7d99e5f075ebe3199bddec9dd2922dfb1d236d83bdcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1eff6fa37702a7bece0389cfdf7842835b595f2e6e4df4647b3921aae2603d6"
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
