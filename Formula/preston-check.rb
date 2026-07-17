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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.43/preston-check-1.8.43.tar.gz"
  sha256 "ff187cf542ad1dd11cf896d8fcf8574c2794bf3424af73acf5cbf14080d83fc6"
  license "Apache-2.0"
  version "1.8.43"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.43"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a715ee3b7ca5e21bfd70ac0df5653315aefdbad304a5833bf93a04d2ec360a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f73bb8bcbcd7d556ed2c77b254fa3bbaa665b4c459106867b11d221207a3a32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d813920b1bc625f1bc2e0c91773b1d98beaaf9787897026817e2611a6b1136f"
    sha256 cellar: :any_skip_relocation, sequoia:       "6a9f673e0a1875cda0c9b0ea16a748da224567aa6453acaa25cc547420ebc399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0438076cd97826a613b653c8c6a5528e9d1afc08bed4d4934fb133a9de92810b"
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
