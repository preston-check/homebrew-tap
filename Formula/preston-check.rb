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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.426/preston-check-1.8.426.tar.gz"
  sha256 "1f4a7efc69be0ae4d9b51a66e604625ef0df1601fbd2592125a5b82c1bff5812"
  license "Apache-2.0"
  version "1.8.426"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.426"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aaba6bf50414959ad81d747f2059ca6d121e5767c1278b4a008588f1962757e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a334088946786fa79903f15ee4c2ee34b90f7611cc557ed6b03f2bf1c904ba4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e395e3f413d82b629656285a02106f8d972486d01a30e0f284f7850ae268ef47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f6165ac7789680f48e9a8a38dcca656970bbd05f92d9a5cb1b3daa32c2c14af"
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
