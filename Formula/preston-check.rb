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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.553/preston-check-1.8.553.tar.gz"
  sha256 "736845e8f74553d2c73d03484237c8f801ee9a29d552e3c6c046849ef51ea70e"
  license "Apache-2.0"
  version "1.8.553"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.553"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d45990e7a9c2460ba2769ae90c8aead8b17de75c59d62e6aa8b257c8b2e46951"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7e34461c098c4d6a9c7fc4ec80c50dd4708d926488855fcd2ccf16319e9b045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ac4d19478f45a54424b570517ba1e058d44c528d7d63274f5f6be56625d6975"
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
