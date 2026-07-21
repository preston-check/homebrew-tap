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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.75/preston-check-1.8.75.tar.gz"
  sha256 "b82570af9f320abc26bddb63c6d87d6de92fd954b1486aa2f4868cf74d70c172"
  license "Apache-2.0"
  version "1.8.75"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.75"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9bb12c2ff8237a1fd51d4b559456cd54876310db730c7c4a70722ecdd52a6f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87384b2852e6070e97bffd042794dbb08066e27fdf4d95bd157171b17a7f5e9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "057bea07e25ccbcaa65f0630b3465675d163c4cb552641f67f30af0d47c9a6a4"
    sha256 cellar: :any_skip_relocation, sequoia:       "ea26788bb2436978ad2529555222072c3971f464c9b877f7e89b7609a7cb4177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0385fb8cbbd11d7c5afd9b8c0dd4dcc699fd36c669efd5ca72bd0b3ed37a7ccc"
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
