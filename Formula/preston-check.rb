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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.484/preston-check-1.8.484.tar.gz"
  sha256 "976a434d4eed2c646fcc5dbb9e39af39b9200ea8cebcdd3b76a00073c1aeb1fc"
  license "Apache-2.0"
  version "1.8.484"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.484"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbcb68fe7b0090e652db14bd3c07ad062952bbc99be056434871fb21dd52506e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c95e40bf68e33c1b62edd2f8a8bd76f07290487331130762ff2979a26ec6b95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8621b3ef512f444bf3ad4ea67bcfd70c62f708e7486eaf106676007ee4b1e8fd"
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
