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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.54/preston-check-1.8.54.tar.gz"
  sha256 "7e47198091a094fd7cf6f0cf98aa9b82ee44d6e0161b2a7b64600aa86e50e4a1"
  license "Apache-2.0"
  version "1.8.54"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.54"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a57821d0daecc8c3712fa4e908e9debda32777ef587a97f7bbb6129fb299fbcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc84e5303989b76483cdcf518cc48b248cb282f353f93bea76b6bfe498e65dd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66f80f603ffa705ad35c5779ec2ece82313afb385c7c9d1286da990d2c7561e0"
    sha256 cellar: :any_skip_relocation, sequoia:       "01d294b6f2bbbdc3ee60f7a7cbf9cfeb45868aac67580b49fd8cf4ec19273f8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5e5dad4024e20f68f9f4263a0ddbe1dfc5acd97cb2574de04e67f024837a52b"
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
