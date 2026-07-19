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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.59/preston-check-1.8.59.tar.gz"
  sha256 "9e29d85510816628da8244ed30cc0af6145fc7c0be91fe0094c1ad5c61961f19"
  license "Apache-2.0"
  version "1.8.59"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.59"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b095770936b84d9666069185980d8bf9cb5c7007c8c8ae26b35a4734e98d810"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8cbb3b9c8dce040aee63840687d30251ffe0ba6832bfc91ab6d65dcd7d89291"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0736678c599aa485e68e9c33c976b4d28d8f48b316d54f1b8475986543ba346"
    sha256 cellar: :any_skip_relocation, sequoia:       "a24bdd27dd62c56367ac83f7a16c997b0f5919b2633d286b5081fad2bf55e06b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5470b3641571e90a1767b7e72dd84c121888f403a6fb1637bf2b5e0b27a0da7"
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
