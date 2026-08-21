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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.368/preston-check-1.8.368.tar.gz"
  sha256 "666b2068afed25e43dcf34f2a1351370be6f3477b22a4c9cdb3dc6ebfd80d7a9"
  license "Apache-2.0"
  version "1.8.368"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.368"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9ef177c88563bba27b4d213af540e3e165a9e9985179f55f653cf6c13685f78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6c76e17952b3d41038b99ef18ba691a5137d98f7db819eb7f10d82ec98ecf84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a13e4f936aa0f272dc3e55fd5f05e4affc42517444e1a1e02b5240a803f1bd8"
    sha256 cellar: :any_skip_relocation, sequoia:       "30cb0f2fbe98a68ae73e9896fb23cb431000001eb8128a1bbafdf5e5f241b1a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27963c9948a7e6bc41cd1d9f289799b4c0fcd33d01d10b2346b04154eb8236aa"
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
