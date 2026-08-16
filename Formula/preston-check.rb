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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.315/preston-check-1.8.315.tar.gz"
  sha256 "d65ad83c439ae7108e8cd1a2710787b490bab4080ef22f88722f11412e524fbf"
  license "Apache-2.0"
  version "1.8.315"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.315"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d8dbbbc72479c1513de4d43cc72a3c4d395fb042e0118beb75c218209e7fc1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "702152bd37eb05161aa77a9d2366934d846da418ac096a859bf716a3677fc076"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1de0dc7f0fadb247306135101f09521c7fab1909c8c6bddd5c23389fbc989cfb"
    sha256 cellar: :any_skip_relocation, sequoia:       "043bf6f0cd615e515e0f75520ba338d3d9f2d86c382b86575fa2ff968881de1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "323967ad64a59c8321109db526a95b2ba59240d2e5861728a2e6f47d4daf9da1"
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
