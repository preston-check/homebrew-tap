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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.378/preston-check-1.8.378.tar.gz"
  sha256 "dc2f9839af386c64db8682dca6a852f3150fdee68bc0a1824f8c3a9a44e5f0fd"
  license "Apache-2.0"
  version "1.8.378"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.378"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07aad2167b8acc12623d07073aa032a8a1bd1e1a78f208b75ba244c50cd3cb78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9292b10686e1dc676e97abbd1d184ead1c8993151b857b16f0ee50681e334d4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7ed86807a45d845da325c04d867e2fd8dfa59b43373087650578b04b94a0834"
    sha256 cellar: :any_skip_relocation, sequoia:       "0a917f8b03fa01741fa63bb3bfd7310c1059d0010686a0dadc4bb3e0adaad558"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f83a1d4114d41df317fb4cac6a04f31a09717c10e50007cf4691c1eef947dcb1"
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
