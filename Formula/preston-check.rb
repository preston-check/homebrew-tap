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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.158/preston-check-1.8.158.tar.gz"
  sha256 "11a9d1704cae40b92e1bfb55fe4c6246a8473f5a97f9a74b3f88f825cf75a9f1"
  license "Apache-2.0"
  version "1.8.158"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.158"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f1ae884d48a4a69329673033b427bceeb1123eda6901ac89615d52ffbf13a2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "256b0760b211f06b1c6d36dcf530188ac08460648cfb5f11f202a5ef9d58532a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b639f95c28d77b903d52b7e20873c9c21e2f993bde4e568c8f751504606694c4"
    sha256 cellar: :any_skip_relocation, sequoia:       "61641bc48e98c59c0f3895fac7aa4ecc6fc580ba5532e3cc2183bce5a2cfb322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "885e049c2b01a4a7bfc69180dabb7b3b4782122b7cfded2fdd99fc5ab1809afb"
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
