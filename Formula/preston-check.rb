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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.487/preston-check-1.8.487.tar.gz"
  sha256 "d7a03793781f2ce7ad2dd188653d8512446f2cb9aca4b9ec91a4501aa0580f68"
  license "Apache-2.0"
  version "1.8.487"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.487"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e426d1187a1290a01a8244c4f0d0085ed54cae60cd31f95ff2e2da6718a94758"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d298953327d8dd7e0e66c656b53f7a8a08d8456661fd9472563ad38b86e700ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15f15aab554224d9e90807f17e8ab8772807ada2e754de11e9d273bfd392e073"
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
