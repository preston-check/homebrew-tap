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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.297/preston-check-1.8.297.tar.gz"
  sha256 "09bc4d6e55512bdc2645033a79bba3dae7217642e5f30d4b2bf9d188301eba0b"
  license "Apache-2.0"
  version "1.8.297"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.297"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dff3882b524d2a800c9eae5deda1229e0a28d2f45031361f17f6d80b4d7c1853"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ebe09b155f46cbcd5e4efad6dd5426ff3310abf4e621d7382dfed0532cf0b65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce3b6c18e79917882aaa6024eab385a5f95ad6e30bb39ae3b1d76ea7fc1a33b2"
    sha256 cellar: :any_skip_relocation, sequoia:       "63d6a2bee1f3d9ca99ad464c4beaa17337c3297acf9b7f0fa6eb531397dd51f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d80e7471f651b1dab869be2086379ff6bde19c049b63aaf8d3c41e113fc0773"
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
