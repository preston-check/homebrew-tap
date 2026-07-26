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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.117/preston-check-1.8.117.tar.gz"
  sha256 "e73db39d0415eeda09b7c8f1e57035ee4f59f70da8d69b729b5273a6fd7512b3"
  license "Apache-2.0"
  version "1.8.117"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.117"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "affc5210601789e3e5f07c3b8d5d226c669ba53dcaa16e408f0c81374c5efcdb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ad22705c818fa37c71cc43030d46fbf446dd8a9492907195a367f3791b22c95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54f4936da8b8744b039aab1b4f127eada45d00f2532a736bdd43c6b7a4636113"
    sha256 cellar: :any_skip_relocation, sequoia:       "c64ebbb61d39ccdc47af026987648266c0ecfe797f2045333929d7ca306e2c4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa3b931d861695c90e6689b03d17f5cd0e9fcf9f0b9b165c7c7e213bbcfe7230"
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
