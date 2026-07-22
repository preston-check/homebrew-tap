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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.84/preston-check-1.8.84.tar.gz"
  sha256 "621fe5c47610b0bf94a8dc18a3828c8df9d561d737fa19b2ea25fcc741ade302"
  license "Apache-2.0"
  version "1.8.84"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.84"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ce02e364eeb70c7d49d2b3607f37dfdbd59ac94830b7e9db84c89ae05cb3467"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45e33e9170915c19950dcb8069abcd527e339be31b44bcda61fc3b45da9b3ee6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bd46cdc1e7d40b5462f674b017f7e90b92d264b0ab70186e3804d33fdb32b28"
    sha256 cellar: :any_skip_relocation, sequoia:       "9c256dd57587ac5cc0805db7532528cf1022663b066b6c7bcc84c52c2ad8b735"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d1793860112bb1060948718525b69d5454498042789e561a0552a0ad5f74a39"
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
