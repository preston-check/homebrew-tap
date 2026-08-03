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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.204/preston-check-1.8.204.tar.gz"
  sha256 "44455ab49394a5f2467400dfc7ed9beaf9c4568f9e0efb47f836be90b8609507"
  license "Apache-2.0"
  version "1.8.204"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.204"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1708496dd1f4831ea4b17895b4b1ea018838ca07a2f6c88164e0f550174bb7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc7fc9f890f061eb146adc0531ff62aca828c338547cbea04954df8c583251d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03e3152f4d25b09ecab952926cdcd0548ce870e7187e68bfae2f394179155cb6"
    sha256 cellar: :any_skip_relocation, sequoia:       "379520f6f84603f45625f5400649bd1675d0ece5923e71b40a30ef2bd69cfcce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d80d24bd0b14b5acd96f2bdff9df7ed52bb9185a39959e8edfddf2c8abbb0bdf"
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
