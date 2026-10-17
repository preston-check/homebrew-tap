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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.559/preston-check-1.8.559.tar.gz"
  sha256 "e6bb6f9bff247123b3a85c42887b8ff5afdd07da6bd66c0fdf885c56c5e6be59"
  license "Apache-2.0"
  version "1.8.559"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.559"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4f727d40213e6aecb0d4f10cd9d1690b5ddaabd777b40e20decb45998e6e673"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4548f8c3491d4826ae3eb705c542a7d45de02cad5a5e19ab9f2b0eaa8beb26b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e0eb06a10e85cafdb54b0a82b52c0b86a8cbc60a468dd4840e80c0af496c85a"
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
