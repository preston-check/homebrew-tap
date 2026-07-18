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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.50/preston-check-1.8.50.tar.gz"
  sha256 "f17d8052bbfbd0ec50fc6de29f2b42d4a25a3faf015f540d0356f97f964abb43"
  license "Apache-2.0"
  version "1.8.50"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.50"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3961f397fa40378a60b7350986984a1937871d648bc68db4bc44a49635e3fae8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed9db9ef36846151ec9bad1002589e78d4d4353f12749c705ac9c63d27241cc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d56328e147e18488cd57021bf3e5e90a85db8eecfc8fbc50571265d66c5f21e7"
    sha256 cellar: :any_skip_relocation, sequoia:       "c35715eddd28ca76ae62e5b1546aceb685f10877b4d0c8ca202cce327a4f6afb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdfaccea8d8f7357a176745120d198be3d8c7775ef6a49a5db4b9807b348f69d"
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
