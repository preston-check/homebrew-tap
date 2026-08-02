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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.189/preston-check-1.8.189.tar.gz"
  sha256 "5f850ffb17c5671f624a22d106dc85077a4cf701366657a15bd118f05f84da93"
  license "Apache-2.0"
  version "1.8.189"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.189"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6746b7b9e2ebfde0374d4f8fc10ed62647b17766cd4c19f96ad789625fa53af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9790f2028f7ead2724b065043c0272e6e885efa5014cd74d62c4cd17d08a9bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3f7dc98fed50b045670d25c5699dbd54e802d7e47fb953deccf3bad76cc45ca"
    sha256 cellar: :any_skip_relocation, sequoia:       "ccaf4a7e7b4cfe8191a69f587e336c95a3c5e75231e23a91070054eb1781f6e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3bc6cda8b29664c7c83bf67570e88b4a20333b2caf19d391e25de18439f8e1e"
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
