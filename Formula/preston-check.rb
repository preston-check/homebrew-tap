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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.40/preston-check-1.8.40.tar.gz"
  sha256 "9f384c5b6fee08b9844361f59b7ef024d40610f1fbabe1b36314f5c5a323c897"
  license "Apache-2.0"
  version "1.8.40"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.40"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b86da3843ab6a4077553c073ea2a8b255b990153cd21446b21ca4164ac0fea45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33e822fd8576084cdf092f3d5968f63b0a10a2cf845e3bb93edae525bb610b94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1475460819fb67a2d36d8594c74a8e533a4e304bace5453964818936ca25be66"
    sha256 cellar: :any_skip_relocation, sequoia:       "8448a64caa457f887381939b2a711c4683e113f837c639a162e0754bb7bb2366"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21c2a5526c78789c48e6d306061358ef6a805d6c3a22560dcca8e771308ec789"
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
