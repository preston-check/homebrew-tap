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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.511/preston-check-1.8.511.tar.gz"
  sha256 "1b190423c38f2f0e57a940898cfbe5b677086d0c0507a8f3d4a4f3d364665cbe"
  license "Apache-2.0"
  version "1.8.511"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.511"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea142a291f63ad7a4024831acac0e90a4e397c69f1eb26418250d201a793ef11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a814d47a88db0224b682dbda9de560a6697edde0d6e59e91874ef47efb8026e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b6652f119d7e910f01f933ccc111e4857bdf64c34fc98ccf5352e462abe8c80"
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
