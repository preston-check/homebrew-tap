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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.88/preston-check-1.8.88.tar.gz"
  sha256 "4f81daafc7d7e65474a914ace7fd59504e6457c37495ccb014dac30f08c3a427"
  license "Apache-2.0"
  version "1.8.88"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.88"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb6aeec5447b1aeb576212a6d731792211210393e61e8decad5583f164d44872"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b131a50ffbf3df7c81b8a6ada43114f32f22c5dc59edf6999b14f2f7e7702424"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "393723b6ff8740e7f4f8a2698ba93597b5650776ec15bf069613bec8363730c5"
    sha256 cellar: :any_skip_relocation, sequoia:       "08732fa9a59201de76bd905c5228b58abe646850d901b0a541e49aa0aac88258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b74524ca7c9c94dec36441d7ae37931acfcb9f2e7a39c15655083285c7ddbdf1"
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
