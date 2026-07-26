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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.121/preston-check-1.8.121.tar.gz"
  sha256 "6e0bee5e23925463c1a44262b5d8c11e6c541de1a7e53c601ea125b5ada2ef33"
  license "Apache-2.0"
  version "1.8.121"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.121"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70a55ebfa74ee9b4102b57219c1630e2db9cd5a3a3c83b8481d1b0161e89fc94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f979b8fa34ebd84d0221390bb6e391c6670e8353479874768d4b9d6d4b93c025"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1e580075ff70173c43b446e05bceb2b4979bdc67de51b7484b56b4baae497bb"
    sha256 cellar: :any_skip_relocation, sequoia:       "9c123bd25046974643516768d95e291902786924566f8c2d06acbf488cbf7ea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ca3fcac7be1aa51cd23d5b1c85b0497b33fbabe4173aceb67f1014c90a80a08"
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
