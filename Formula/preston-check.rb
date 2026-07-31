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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.166/preston-check-1.8.166.tar.gz"
  sha256 "00b375d93056b5562bd8ba710c1217383861d63cc29c6f4e376225b0f64a8535"
  license "Apache-2.0"
  version "1.8.166"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.166"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a3acb5f374cc85863f96f6090d780586e0010c81d0f07b99857b011fc245d2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21eb4963a0916b000cfb9f8a6138627f958ed0c31181df7d9e6ed5408e1900d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21688a6da85957acb277cd4ab15d7adb54d83419f3c2ed72590cb1910c97aeb9"
    sha256 cellar: :any_skip_relocation, sequoia:       "e54caac06cd830c61ae5e951bc535956aa08b4a3be9c50ddbf710e0537ba97cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0b39f56391e3ffeb476673ff2a1f32f6f2498ef3b7dcac0d6f205ae6d1c1bc9"
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
