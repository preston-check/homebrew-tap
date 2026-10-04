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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.525/preston-check-1.8.525.tar.gz"
  sha256 "6d24ee0835a11a34db75efc877e96b7ba0c304e46ec643d46cec4ea10c932e4a"
  license "Apache-2.0"
  version "1.8.525"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.525"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89ff987013df609bc782adb302727245a2c29703a89f5f2af687d5d531769419"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd1339989ead3e7b9d8a3ac7c40c1055f2f2b05781f311dd2f764564334d649f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "926ac231a8d2d239fd446c83b98287a07dd3d18f3609c045893c9fca3afd35c9"
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
