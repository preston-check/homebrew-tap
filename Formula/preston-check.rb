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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.256/preston-check-1.8.256.tar.gz"
  sha256 "0008dd7d6ad7b03c77661f66985491b0cee9e0313e8ce678ebd83ff4256623e8"
  license "Apache-2.0"
  version "1.8.256"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.256"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7911959e90042a8e35694ef0f8ada9b70c9ba8649a5dc35061b12d06c588a20b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca8eea308b4f9c50300a9ab32b3dc7f68c3fa7aeeed257414984883190f075db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6082b1612c493eeb4e84fd91435624cd7f1a3c58c02225d3907dfd896700287b"
    sha256 cellar: :any_skip_relocation, sequoia:       "c249648e6130c5c2e408b2f28597c1948f39563f2b3c47b32e68b013a0ced4c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d912a83e3cad067bdc9791113197a40ceb52049392d0df38d54d36f8a228256d"
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
