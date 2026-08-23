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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.376/preston-check-1.8.376.tar.gz"
  sha256 "3bcc7f308999caece6065479cf4ad97bae9fb1ca691a2fb90df48924914a40b3"
  license "Apache-2.0"
  version "1.8.376"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.376"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbb53d9039fcd49c6e650e199c0770774525382c489197c9c25bbbc67f554176"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37f2ec1dca4f134f79f07d74a491de2632a956bfa7a61131c046f202b570ba44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39e0f94be76dce71043dadfba23fe646aa2815ddb7e2d79c1238096ca739c04e"
    sha256 cellar: :any_skip_relocation, sequoia:       "d1b22bbde747db27eacdc9e5d74911837e37b7ff44becf16113ac4aabdf699cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7168f2caf0607bb5767298d3dcb3511170ff149401b39d609af65081ddce509"
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
