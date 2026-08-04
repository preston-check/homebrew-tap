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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.216/preston-check-1.8.216.tar.gz"
  sha256 "e12db366c9cb8ad5cedc2dc24908ae2dc709abb969ce62aaecf14755ee0fe13d"
  license "Apache-2.0"
  version "1.8.216"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.216"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "315e0cf169ce88b0bb55534fbe1d86003b0fa250722edf076fc8d4218ee14980"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3e2b36b6cf24bc71e4be9c79e73395df005f36245c5fadbe67bc5e9dcede124"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f13e71fa76f96883bce42a0cb6ab3503775b2eeb9bcc838fed307beeecb6029"
    sha256 cellar: :any_skip_relocation, sequoia:       "8618303b4f6dcb27494f41c0366f9316b8dcfa185e65d80ab6d5695b42779b48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d588e1aaf59bb29d6058fcf3c8eb2eaaa4ef9393062e3516e0d57aa3ad149ca"
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
