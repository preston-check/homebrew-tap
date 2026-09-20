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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.493/preston-check-1.8.493.tar.gz"
  sha256 "7d5cb940cb00b5934a4c3192ce33d19e954a6ae48322f41fd996189080487ef2"
  license "Apache-2.0"
  version "1.8.493"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.493"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a472d29c09f916b7e4a64576bd53ecb8e2b678c95fb039d6d3a851f19f623c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a5aa16f60c9a0e6f762136de4d0af125b0d6236642167c0c1dbba3c6e7f3ddd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f4819355fd14486043ea1f037f57104af8a15f12b6faf8a4ea7ec905f3063ed"
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
