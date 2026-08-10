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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.298/preston-check-1.8.298.tar.gz"
  sha256 "109fbbf82ee750f17331a76505232a84dd7dbd6999d54ac38ad715ac370e79f2"
  license "Apache-2.0"
  version "1.8.298"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.298"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a8b51ad04a16433e49fd6bc15e91ea1d022bd9763873048c279a60053ba444d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d61192dfe17b1c064aef0201548b3aaf43dcab1a6214ea698070bef51221b346"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4f6f7dc57ac53f40908096a14c8ab41c7b7b0bc4fe86f92927597fb9cbf6e98"
    sha256 cellar: :any_skip_relocation, sequoia:       "dd2e177a0b02a4c291c5c3668a8ceb65a2f778e95cb8e91467944a785e43d643"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37a5af505514fd72aade8cb0330ad28d71f30b07cf5797a776e0a885cabf2667"
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
