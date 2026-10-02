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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.516/preston-check-1.8.516.tar.gz"
  sha256 "fabb1491ecedd1ebda94b51df799074d4ba25afec3aa3edb57cacb0d8f963e6b"
  license "Apache-2.0"
  version "1.8.516"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.516"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f49ee85578a5e710ce72c06b579ddfd21bf6d0c93d8619a13094a454ffb0312e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27b8c548f53aa74e10c0c07b29e1f4c94d989601db1cb7f8ab2000ac1c07cdab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "547b95449f9d3a6951b8a4ba9ced88b1716b5903e4d97264bbf82edd222c072e"
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
