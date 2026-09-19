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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.486/preston-check-1.8.486.tar.gz"
  sha256 "0777ac3d218acdb4980f989555ca9e0a8a65d9771ef66b87a4186862dfee99bc"
  license "Apache-2.0"
  version "1.8.486"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.486"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e090d519e92477d9a2b040d3d2ced8e71e0ea5250c48529ce1c61d14ee9d7745"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f1d7d4fd20ef812135a85a282567e91134c1e3b8f67d7312771cc1b996742b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebca923034a09cf85ae8727786d6616e231b6edd89bd84ae3f903ba1f3535676"
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
