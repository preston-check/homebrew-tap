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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.403/preston-check-1.8.403.tar.gz"
  sha256 "c1efac6d65f6fb80784d8072dda0c434955fd749b5753663b141efd186880ca6"
  license "Apache-2.0"
  version "1.8.403"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.403"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c84b73d2d7d3476e7d29de5700e67ca2f3ac449469e4972c2bda72629fbe8d82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "227811b71df985134490a145d21b8dfe653b7cfb91320a2e0c87adac769dba2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab108603e89fd7cf9bd5af8b556d3c4b4a1f99fd65b5c4ee63d457cfa48174a8"
    sha256 cellar: :any_skip_relocation, sequoia:       "dbf936ad990fecbe85edc2ca373aba042ce3b37caffac2d3eb0155977d48f83d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73531249ed852c1824bb688d249b3b7051ddac1f438a0d528a9b38320af5d0b2"
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
