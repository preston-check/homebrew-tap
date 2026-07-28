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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.132/preston-check-1.8.132.tar.gz"
  sha256 "5e13e87db0ebd4e0506db730c08ff4b186a93a3afc5eb820d101f4afe3990a2f"
  license "Apache-2.0"
  version "1.8.132"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.132"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50b207bad8f6368ac7b41a84f06baaac69de8f7184be4e097844d45d78b19597"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7852ecbbc697fa7ea7b7ca852071047b27a97757ca70322f590ec0e453a431e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "914044a05375d555e0b23961d80d34a636e656bea000f4c9543f345c3425a499"
    sha256 cellar: :any_skip_relocation, sequoia:       "bacd7429d7086593142ac76888b30ec090e12fbc37ad466e557343538bb8ab25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "202e07d6048dd0ffd5dd454f437bf20d79b3215d446413bda7284db68b9a8d68"
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
