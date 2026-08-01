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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.172/preston-check-1.8.172.tar.gz"
  sha256 "a6eb5a1dca7386bc5977460eacf16fa50da7e69306e620ff3339daf7b77a8db1"
  license "Apache-2.0"
  version "1.8.172"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.172"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f89c5e100af6187c3118d9104e8b21cfcd337d6482024cdc677d6294b0764ee6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5f5b1801745dba9d3986203d1517e11e35519e7c77623980cb416bbbdb82dd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "536a8bb394c97dcd5d3a62b977058fbf44ba5c7730c1d349424ab5e813601a98"
    sha256 cellar: :any_skip_relocation, sequoia:       "0559b49fe330a9bdd5e80f7ddf63d0e510c21e6113906c19b2299181326fba6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4a008abb4e2f875aaac9fffc0c2fce9354f662ef0a415b9ba9c8076c530e951"
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
