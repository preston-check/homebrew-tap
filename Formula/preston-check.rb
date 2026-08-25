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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.389/preston-check-1.8.389.tar.gz"
  sha256 "533ab8e39e8819c98ea243b37003da385a83a48e49aa37719156c09a95e01dee"
  license "Apache-2.0"
  version "1.8.389"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.389"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71b7f037bafa39e06cb9cd3450240ffd371cfc7ff39c07a63dd43ab646cea45b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a21361ad4566a482b5beff55864313888501706f6d3bd3f48cd1bfa6d01213de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6513a49e05b5be8d5f9df730e169d90b3cfdada97453b9fbc39c19f518be07de"
    sha256 cellar: :any_skip_relocation, sequoia:       "7ab6f5cef12a569148c407fb5f6664f9183878bdebbabcf4d190bd2745e7c2aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82697267694a9e5331d0cda2b5873df2c034673fdad713a0d257ddb5480e0dff"
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
