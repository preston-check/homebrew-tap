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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.540/preston-check-1.8.540.tar.gz"
  sha256 "9dcdf259be26ffe4d038a0c62ecaf9222ce850de6867d99eab31678463935060"
  license "Apache-2.0"
  version "1.8.540"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.540"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb94c70e060d748d2a2901d0fb4ff41f51e845224647cd91ea4e16fe331a8451"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cc9428a6802f45b0f660784f5521fbf4451e5f0c040676945eae21dfbe3c196"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ca2cb18e80663043691dcc54d86584ea15bd7d95f082b52aa2c06297cfb8d56"
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
