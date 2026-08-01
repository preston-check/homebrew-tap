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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.177/preston-check-1.8.177.tar.gz"
  sha256 "9e287668abbe111efda9d80068adb62aee5ba76a3e7936af8fbebc2b912ffcb3"
  license "Apache-2.0"
  version "1.8.177"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.177"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d0c7e77e33afc1b3e4a5f4c0c8918a1a721ec3b78140f3596f7b6111293e97b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4cfbffbaaf542a0884ee27cb1af4090adcf4457b5d465cf8ab500a85e61610f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc3ae61f0be9cb55094d5623da27783c23ec9736f4441d76e34a5ef0549e73e0"
    sha256 cellar: :any_skip_relocation, sequoia:       "07885abe9bd3715417ab1656bf241a249eb788b3d6fae1bde581ec2f8520a5cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eba09b1e825e98227d73d3ae43afeaee85a36648e8d02df02d9a558f7f7602af"
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
