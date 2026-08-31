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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.410/preston-check-1.8.410.tar.gz"
  sha256 "71e445347e6f516ee06a0bcebfa6e21ff4689b52f73e712c704e27d809f99387"
  license "Apache-2.0"
  version "1.8.410"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.410"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efcc510cfc29640849b82e58bec20a108a3e2d6d53fe5e8b1d5bd40341ee9685"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8364a99f147e2f266289f849ba593957a3a73681179b89343d69e2cb493000b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fb60251682380685a9a3f18a4d37c408cba58fa52614a57f8e1810559af5a5e"
    sha256 cellar: :any_skip_relocation, sequoia:       "9a44f53255ea5207b6d346471764d4d4b57021c3e2f63a53f6f455cc5b92b2dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc9bfc0d7a63f8536ed9584ac4e9329f21ce0ff7322ef316d402e40e4afdbac6"
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
