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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.280/preston-check-1.8.280.tar.gz"
  sha256 "9e2df60b003e8421069a046565ae5dff0b51010468a147c3fd3b0f9ab5ed1e1d"
  license "Apache-2.0"
  version "1.8.280"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.280"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c985e29fbf3ed930ebdff882f8b965603223cf93a4947e8551c3ee33aa4d2d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf2fe51e2a3f0080c6fd38c41b9a0a153f8acbf85766872cfc44e33f9371e2fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e84c7ecdd66144d1601074e4246e6400f7e4454e62204d7c1a8b239ba7a8975"
    sha256 cellar: :any_skip_relocation, sequoia:       "2138ec45c13d3bdc030d98427e1a24408c79dcb895e6d4eca8b213c4f8875bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08a207b431763c2e1a93039adfc19cd0af6f7678d4f3b3a4186ce7bfbeba752d"
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
