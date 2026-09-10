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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.439/preston-check-1.8.439.tar.gz"
  sha256 "d082e03ff811e877efd490a0b00823ad1d93b6e6f62425b48d15262269ace4db"
  license "Apache-2.0"
  version "1.8.439"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.439"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f693d297ee0fbfc54fc81b61976a53ef903a28f4d7a787e06e213ed350c753c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7fd8ee04695c0e6af35596dabe75c733b9db67c0408e2781b497f1256810378"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "530159f94af3f5bd66f89328fa5f7254b696cf5d1af079012bb208c78fbf7132"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51fb4829104ea4f341ca5b6503931e8526e2ac181fe849e08631f89ac677a5a7"
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
