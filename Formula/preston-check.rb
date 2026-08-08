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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.261/preston-check-1.8.261.tar.gz"
  sha256 "8720ed2b632500d5ad242d4a84051d7423c9a8380df7f7d2098db3dad3a6394f"
  license "Apache-2.0"
  version "1.8.261"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.261"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf01d7d8068580eb6f940359a7ace45ec06cd42413b8a43b4d13d28b1ca7e0fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "300e68df54448e3288d640176040956dac020baff81e027311cf1555564135f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b8d36881c2b550a9cc590c7e60a9232722baba307a72cc618187c26cb4dc342"
    sha256 cellar: :any_skip_relocation, sequoia:       "decc5eb6e16a0727286ba61aafdbd5701a61d7eca40bf7f22a5e3fdec52a5962"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f933118c29151121474287b7cd64455ec674b81e6d023b7eacbc76704b833ca4"
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
