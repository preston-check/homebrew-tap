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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.360/preston-check-1.8.360.tar.gz"
  sha256 "5daf00bc7a2d8d964d6805652864df12751eb2d4fe07d42c8bcfc894ec999405"
  license "Apache-2.0"
  version "1.8.360"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.360"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f04b7523f326347ec2043daf09e31af4bbda1e36c01858226ff3860f034d5132"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8968fdbc7f9a02e8f1f9f2bb6dc4a17aff5df5d4eb5650f1837a0549363a958"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33c1148c2cf35b5bae6bb583964a5a6b0b958dd8352f86af075c60e7c21fc8e5"
    sha256 cellar: :any_skip_relocation, sequoia:       "0a0e8637a180202ee450b3c714d8ac823f4dc3f5516a3b7c68d99678cc8e4f19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d86260e08cd77eaae7c56319874b5826a04399096db8e3eb8c00fb531b379891"
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
