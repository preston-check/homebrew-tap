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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.64/preston-check-1.8.64.tar.gz"
  sha256 "c99446bf87646b718b7d89fe5a3e4df7d739d42f329cd59840f1c2811d215935"
  license "Apache-2.0"
  version "1.8.64"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.64"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7711155dbe08cf39e99e0fea8b8e09fdce600891ec0dcb6fec13aac22a5b54d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e7b805af9c2d6a462079afee6a8b5260d26afc07e01bd01ee24cd593d6123ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20e0eb373f5270e57bed6487c957cf652f3c851b638d033efd16d3b1110100c3"
    sha256 cellar: :any_skip_relocation, sequoia:       "8ed42df4d313b1dda8bd726d4996b46f4e577f3e29db3f16202b74a6c855edec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95101d0110dfb56f6baccaf81dc89a3814730b7eefe12716eb071829c4040039"
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
