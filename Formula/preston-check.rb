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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.67/preston-check-1.8.67.tar.gz"
  sha256 "81066267dfb158496aa052f7777b13d1f611ea6759f9364298b079bc5f54f1a1"
  license "Apache-2.0"
  version "1.8.67"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.67"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c58a90cd284df49d09d411a026c189a97fe2f75d60958fae166e8feee775c671"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1081e4dff9fb4e9085fee28ffd5e0ed84e9413a635f14c3d68fea016f67cf70c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bdd71dbb986db5abf65debc0b79389186770f9f22f14c6e70cb8a9afd873dcf"
    sha256 cellar: :any_skip_relocation, sequoia:       "60d682116897f6429b3d9b952461e3286fa80280491e00dbaef1a9f5d5815eae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2742e5b59d15a6245722093fdb4f283e279d9682d0bc6f2296e4856ff4df4407"
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
