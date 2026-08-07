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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.245/preston-check-1.8.245.tar.gz"
  sha256 "f45b1cb74db6de67a0439f8faa294eb87b18d0d646b7f19405cd2f4b386ba19c"
  license "Apache-2.0"
  version "1.8.245"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.245"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a57745a1dc31684c9fbd9633e879caa4c969229aa67cca4e51203a988b31bce3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d87c696c4d5546ea7f307f58099e6b298297c911467ead8c99ef24fd455b6b8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd91bab31da52450ee6b5d6b2260ffcf79a3fd624fb225341fd72c0a3a4d2b2b"
    sha256 cellar: :any_skip_relocation, sequoia:       "716da0ea844adc30936cd266a119b2efd42dcdb44e10a1fb9bb5cb89ead0a3be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "622c3f22a51adca690a684e6d9d17925c301e222dd093ea090f6f1b79f940105"
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
