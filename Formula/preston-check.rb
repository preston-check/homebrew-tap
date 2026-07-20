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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.69/preston-check-1.8.69.tar.gz"
  sha256 "6feaec5bb8f82f67e8c6f81bea4f84c6b68bc1988feaf45a8520f7a5eda31650"
  license "Apache-2.0"
  version "1.8.69"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.69"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3eb4a08985f52411a33ac8795d3e9d0d5c13858a8567a35b9cbc48b4a237db6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bce243c563f8170a1829f7a125c8a4daafc24c9612c6d7cb2288857b758d4ca8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1571b8afdbb4d7a55238f8be8284527efa16fded4c5d413335dc0321f0261604"
    sha256 cellar: :any_skip_relocation, sequoia:       "bd99755ed310fabeb2a7cd4888dcdbe7e92748784b3644dadf7c4471c3a5f190"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83f273c1634a9a409f2b2c1ae6944cd7c99262b08827cb99c696a38bf434ac90"
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
