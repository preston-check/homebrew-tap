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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.291/preston-check-1.8.291.tar.gz"
  sha256 "8bc90062302ac5aaa12fa70158a9ad93cff3a79c3755cd07b4921c69d194d2d0"
  license "Apache-2.0"
  version "1.8.291"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.291"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1918d082ff427a1b29cec805e2f934c3793967587e51aec4592705946559ff9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27ec700150f79a9c5b3ed204f0cf72798295232a438c11766c1ad33bf17ffe64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51033cd2b20ee57c1c9789591381cc0942117cd0611dc3bb0d9faf8467d54848"
    sha256 cellar: :any_skip_relocation, sequoia:       "979db278b496152595a8aa2a1617b9f71586600204ae22c3d831ad60d35b5be3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae3db706f5d05e1fffa8ea0d9304fdaf5ba2dac337a74374c14c9a33d2cb131f"
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
