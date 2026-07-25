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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.104/preston-check-1.8.104.tar.gz"
  sha256 "841ad092a95aca774995255671a281de8bfa02d6df80520ed9f6f7371b650d45"
  license "Apache-2.0"
  version "1.8.104"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.104"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3293ed2a0393479ffafb5fd12b3366b9e719669bf0f3fbb24f20cc29073f08b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faaa0bcfc000882f0eb886ae6eaca0cec61f1b1ed7df15ec76eda5e0daf94381"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3a8dc495312c4a3d309182e43c069e234e916101db4cf2587a42ca77bf01be7"
    sha256 cellar: :any_skip_relocation, sequoia:       "2433c510bdea55cad9ade02f81e910d02fce1b0a1631fca94ad91b1fccdcbbfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47c125c22549ea91b04b99ccfca8b0f2edc472888439d8b4a4936ce090e89dbc"
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
