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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.349/preston-check-1.8.349.tar.gz"
  sha256 "364606ef1fee35852943f556ee4c9c3ed6d84ce3d22befc7086d7738df884561"
  license "Apache-2.0"
  version "1.8.349"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.349"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef985d4e35f4d987599ecc703d5876f1c769b3ff2ebe29f6ad0a00ff1b1c8236"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4c9a62610be7cd077eaa4be3b2e30838ba69d3ab16d0a4d8d8d9242598d9734"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc282905bb10e3ccbcbba50bb8415f65a723800cf6ca78199ce4b07b1477da63"
    sha256 cellar: :any_skip_relocation, sequoia:       "c314565ed2d40dfe1ee7da3ea047a8b241427c49f63b5dc371af536925610170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2648f47dfd1003affb8976786adc8b87f96e00759383abc6f3f8052f9035f52"
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
