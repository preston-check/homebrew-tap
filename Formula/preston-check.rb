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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.92/preston-check-1.8.92.tar.gz"
  sha256 "8f06676e4840578534ebc557aace8914a3d15ed41a93ba12e3d5ee06055a10f3"
  license "Apache-2.0"
  version "1.8.92"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.92"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "268e3a4e962c18ff84a8f9f9612979efbafb48beb13d07f6677cf333af680068"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74edee4f10d3ec23b8bc22dc42860631863b2363da946d9cd8449aecfcf5e7b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "273b6b8dd4a606ba36f6521939e84284f82069a0073122b0efee8f2ca4b1b9cd"
    sha256 cellar: :any_skip_relocation, sequoia:       "56083503adfe3e91b01d3a789627035c68c82a7ca6ba939ec5b4ab96f7010da9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f48e644f2441249dc7ca12e890b5e7eb84d5fdf52a4ddcce9546c9bcd5bdb01a"
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
