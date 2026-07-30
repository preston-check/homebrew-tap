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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.152/preston-check-1.8.152.tar.gz"
  sha256 "8ad8b78c77c3aa8daed13a02f564da4ffb5fd8267de3d123699533b4e625c177"
  license "Apache-2.0"
  version "1.8.152"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.152"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2c08427b43a9dca946fbc608c0972a77baa394e434587a87d9369eaaeb0992c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bff918572def831092adeaaa14baa5aebf2b6de9323958c74f1bfa1e6a4a6da6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "801d77f8d45f1d8785e5678b67b02633d6af8f20e8f621516118a7a6b65c071b"
    sha256 cellar: :any_skip_relocation, sequoia:       "7f09275997cc864c94adab63fd7d099ec988c3451a8d29903d25a0fabd8ab38f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b71ec2887e394f63ea5e19cbd4f4cb742d6b15897bef65ec72c747f3b037bcbb"
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
