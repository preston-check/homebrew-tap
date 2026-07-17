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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.42/preston-check-1.8.42.tar.gz"
  sha256 "cc72d80fa99fa9ee2b1b32a24499f46b8e7ca885bd5d8f0d40a51ff3db25e3d7"
  license "Apache-2.0"
  version "1.8.42"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.42"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ebf20ce3acdf893d821b4a69dfb1172e0ed90a7894ce8612ac4ff37d78c0b79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58000495484815b847f3ec25d88552192991b56eac880dc21c1211c888da81fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64ef9fcab0060f4585bb876fc18dba6f187f7c2634506e39dd7ae8dc95ef595c"
    sha256 cellar: :any_skip_relocation, sequoia:       "6539c453946e7c2b20efe4c312641bd07b1455fc1591f6ebe281cf7e0e21ef84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d5f72da501b94f5e6760960ce407c83587a60199a649f5a772d39a248930c83"
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
