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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.380/preston-check-1.8.380.tar.gz"
  sha256 "be47eba3f936c5ef0a84df7cbcf4130f3b8cc4d51de3d2b2c71fc32976a3ccf2"
  license "Apache-2.0"
  version "1.8.380"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.380"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a68a4b04cc9f0eb2247cfb57573615968f37407a636a80547922f2de3cb8f3a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0f2e074e6e93b7a918857eea00c7487b187e6dc262b718596a6862fed2a4031"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43c5c78917fb785910d3784fc82a40159ec6bce81f272149d2f8c10afc8902b4"
    sha256 cellar: :any_skip_relocation, sequoia:       "03ddbf279dc816546a0cf4e413ec39b9a638b848f8f3c71381fd6e079f2cb921"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7afc0946dc8fb08c5157f99808eb5e5cbb0e2c5c894e8961fe70ae7bfe8ebb47"
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
