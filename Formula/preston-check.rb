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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.405/preston-check-1.8.405.tar.gz"
  sha256 "9ab23a752905c3b47e4f8a1187a241a97afe91f30b43f47268d36cde7b94ed31"
  license "Apache-2.0"
  version "1.8.405"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.405"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c232106de2292f75a0a8cc8f5cb87aef7122d1b5951f4957c4e472d04ef7853b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3b71da23e43716f072d2bf2223bdbee210331e892b77cc3267c36d0d07f1d6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fede038cbd73676bf029ebf98ce5eb09ce65ae9c765891674b134754691f3103"
    sha256 cellar: :any_skip_relocation, sequoia:       "00257890586de5fa0755aa4c81dac1054fbab361df488a43b8f17450b60d44b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "215e041a7c1c914135e3afaafb1275f1ad4d48f1438942ff11efa1244c159252"
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
