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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.136/preston-check-1.8.136.tar.gz"
  sha256 "797fdcb3e6dde99f116873d405d60a5527774b4b8a8f17a1c503fb7df6252912"
  license "Apache-2.0"
  version "1.8.136"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.136"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ded865415f6bdb33dcd2c3bbb6667d6f3416303ad6186eef796a4d06883d9932"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e0dba53a41be51fdcbd22632659c7f36b39fc3e5baf399d5a7cf8c351bceb49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a6672711a652392abb47d516d77821002b6c7562310491df5908ef778ce2bb0"
    sha256 cellar: :any_skip_relocation, sequoia:       "9b571156dd3e1830f5fb4b1c96b7b1f81dbea87a47facd00c7bb9871ff323fb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "941ec9f3d8cf2dff259fecc20ed3fc85f7eb5d8840375b1c0cb7dae9b8ccaa67"
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
