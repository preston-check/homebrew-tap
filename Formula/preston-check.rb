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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.70/preston-check-1.8.70.tar.gz"
  sha256 "55d7c9e8fa9c7486ad4c1cffd5246a4ee644386038d964a6f681d8306747d505"
  license "Apache-2.0"
  version "1.8.70"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.70"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06de6a6806e17bad36b91c31fde42c2597f8dd4e9a0b1b3ba72c7b184d9e3b92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d300f21448d5d7ce5622aecf082740b667a5adf32e367e300b7f22bf381ff3f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24c8547ba1c7c1cfab018627f5508a9f5d1bd3c13a1eabcce4f8f623f43ced09"
    sha256 cellar: :any_skip_relocation, sequoia:       "7856a385483d5643aa5bec5bc3c8366637ea7f800e383e00d163e498249658b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddacb992a0205f9adf548c93fd3871818a3c04c55f3d4ae5a97ca286e31e3dcb"
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
