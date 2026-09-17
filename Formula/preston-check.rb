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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.472/preston-check-1.8.472.tar.gz"
  sha256 "7deac007921044e3a00b6e30197436af47b468f39091096edaf38d19f04a38b6"
  license "Apache-2.0"
  version "1.8.472"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.472"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "800d22cb35d9818c94eafaa4983284fde8f71cfa58b52565710cb3b5200191f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc73558148e29a6daa011312b9fae001255b39b3c5226cff324d5444a5556ceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1843f7b92e151639447887a5e7c89b961c2948d1965cfc6d85c0fd5deb425e3"
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
