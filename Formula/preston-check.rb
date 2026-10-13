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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.542/preston-check-1.8.542.tar.gz"
  sha256 "83ffb8131fa19afab6db54635f4993c5cd38af6336a541fcb10651503a966752"
  license "Apache-2.0"
  version "1.8.542"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.542"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af56765a5cee04dac1d8909c28db9f2d8953508b9c4618c7829222fe339d31ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e6e60de8e17e2dc62709f8ffa3d5eb2ec7d8e57f2c2e561182e10b95fc86567"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "128db97958b06769def1be90e30c19e304eff1d77b30631138a27302f27058f2"
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
