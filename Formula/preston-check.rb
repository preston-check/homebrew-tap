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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.258/preston-check-1.8.258.tar.gz"
  sha256 "2a1aceb09c16edcfe15f84f1f2d7c3fd4bb488a4de638ee3813a109353cce1ed"
  license "Apache-2.0"
  version "1.8.258"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.258"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14e3892a207b93161ee5b6efeb0454c315fdd1928eb3f6c70f7ad9bf37f63d7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e16c60bb59f181719c5dad31f5340d77f15ccde3cd6e382722416294c12fc7bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8838a7582f3d9f0f92e534f44a74ab71cebc56a19eece0642c3c5ebaac6cd60"
    sha256 cellar: :any_skip_relocation, sequoia:       "4203f32c252519efeeb9b9b25e15c52548be13e68d719a4391b6bbdf53da1ad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4eea52aa4c3d96775a5ea0a73c940d5051d2947042e3a93f43d32afd67e8448"
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
