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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.273/preston-check-1.8.273.tar.gz"
  sha256 "8bddf457e0306932139d900ab4795a599eacad558edb8b557b0173a9e05a7cc3"
  license "Apache-2.0"
  version "1.8.273"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.273"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b685818867e6fe2b3d1ca4a00f6726a35291ca9eb2b40919a9ace01fcf7003f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17a5f87c50bc0a8a3f6217bf9fc0e72652d1d1d67bd293db0932cd2286dbd93a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aebfe8fddd65daf49304d955db07c1d3fded9d2d359a66e4c8b7e20abfc20754"
    sha256 cellar: :any_skip_relocation, sequoia:       "455ed04e18130a47f3f5b1b07fd58051e7a4ce4e8f1ec9fc305776fedaaf5306"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5beddfb0837a21a71e63f153b62dbc55d58fa8db6122e290d387d3758082168a"
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
