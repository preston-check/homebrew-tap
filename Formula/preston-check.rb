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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.314/preston-check-1.8.314.tar.gz"
  sha256 "de4e31a348cda5f74cb44fab997cc21ba0cc0e1fcbe76c25fb090f6066d6254e"
  license "Apache-2.0"
  version "1.8.314"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.314"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da90b93d31bc2b5c0d74e7c4db3d7ac7c075de71f0537fb817ecf8641b2a3b1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "478a77ed4deb912ffcdf8dcbd06f0441a2d50be4b437c93c27774e142b7bea04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09e4fefadb722fdfbd63a2317f23bc190887a5adfafee37fcbb307314060ffa5"
    sha256 cellar: :any_skip_relocation, sequoia:       "d8bac5dfdbe252a7eada81eac965db639ef810ad59e4017ad022f3b0e1446fea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1535d48dc1fdcd1cca4d9d2b5e50a160d257c0fd0a2ac88e08c9146906522f8"
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
