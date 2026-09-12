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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.447/preston-check-1.8.447.tar.gz"
  sha256 "6367180071ee2316764e791bd935a5ef2eb804b478806e604f10d1c5f58f92f9"
  license "Apache-2.0"
  version "1.8.447"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.447"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72880e70f73b732bece8bb4b19d180961d611f7d554566d98bfe0956cf9e003c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f03c5a905a1d9467b2e3fc1788405b46a7086bacec52cfffac9e78ed14d65e6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "970f420399ad09b6b17006b0bf60fc8e7366955906a703c5d9266ad89a09c335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb03faf96efb14e1168d5296c717c96d7ab77eee4eced241da8eb52109b0dfc0"
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
