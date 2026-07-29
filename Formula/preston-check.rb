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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.148/preston-check-1.8.148.tar.gz"
  sha256 "6550e7e81f7e5958a39af49092ef904a1bb78e00b64e492b2b9c563c955f1f7d"
  license "Apache-2.0"
  version "1.8.148"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.148"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbad93a29190ee44dad97075c875b3d6618912915eccd09f321a37a78c910a0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "226bb3c52e62fd7c3c0483f6b7f18b2aaf477498c8017bba3c9241050823fb3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dda7508ae30d8fe2c803f7c265dcb2410e2a92a0d4d47df3a2a9c4b7ae1d2b7d"
    sha256 cellar: :any_skip_relocation, sequoia:       "3db90c49fe08434d884330a2e84819c555ebac46961b02dd9fcbd544ca0036d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a9e2397ceb5076dda1aa224605eef24127d5a723e769fd6fde5e9c91a0166d3"
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
