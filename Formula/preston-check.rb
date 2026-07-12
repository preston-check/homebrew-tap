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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.1/preston-check-1.8.1.tar.gz"
  sha256 "c1328d0cfa24f8db595252d8ed7748f7459728f41e12260bd63ce0c085433b96"
  license "Apache-2.0"
  version "1.8.1"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e337d93ea26d3a36095902560ef72a3b14ce98a43ad597da9a1a4735bd5ee9bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e13c3946db4755ba10c8bbe565ba39237c7a794c1c0e58625a9be9e8b300a298"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "512ff5c330cfedd03cba4821045dec89e17f30bdd2fdbe532ea69c69f8e4dfb0"
    sha256 cellar: :any_skip_relocation, sequoia:       "faa82c647584a0d31a39ebb9510bcc6ac72e3b97baa92fc82dad2d733dd0f5c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f34c3601159cd17901f437bd1b634bd4afea0182d1cb7110db63a1fed7e7b59"
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
