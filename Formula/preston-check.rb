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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.363/preston-check-1.8.363.tar.gz"
  sha256 "fb859f44204101a0e10e2e91cec0bb774ff43d3963ecf818bc9b313036db8f3d"
  license "Apache-2.0"
  version "1.8.363"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.363"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57d36840297c2a3ae7e45545ef18c6e147ec091c26df24ee619274399d8e04bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2e50a191a37ff953d94c44418f30544a1a872245ab28a9cbc62d978f11d0645"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "231388cf79779dc211c143cd89a55ff92930a1920a7f0696c6d048e5a39d8e00"
    sha256 cellar: :any_skip_relocation, sequoia:       "30e812ed79a399945143010edaaafb7841b326ab386208f9faf592a45296ae36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc04338b44cf776ccff3e254a5974a5f24c3afbd2d62040ec069e3101c6304c3"
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
