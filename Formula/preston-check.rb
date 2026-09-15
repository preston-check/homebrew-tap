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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.466/preston-check-1.8.466.tar.gz"
  sha256 "f43f7a685fdd704047a4a71f84d5ed6778a5746de1dc39dd2f512d42ff159f65"
  license "Apache-2.0"
  version "1.8.466"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.466"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a11048d0ee8aa141b4af4cc2ff1eafd57dba919bfbf0a5452506d2ed41abd253"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5008f8c3a3228a763c9736f6544765089017b94ac3d2195dafa65729a8aaade0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40e3d3d32e16f8d1b7aaf0887a29bdb85695430d01c4223310005e0eb1396042"
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
