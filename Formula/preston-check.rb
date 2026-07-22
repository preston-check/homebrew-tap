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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.81/preston-check-1.8.81.tar.gz"
  sha256 "cc05e4d6c5a1939fa10e3f2a89a1b321973574b2764ff46dae45b1a09f24b138"
  license "Apache-2.0"
  version "1.8.81"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.81"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a94555b6a197c6355e3170e052fdd0e1c01c631fd9bcfa2084a5be1eb033c6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "565ce8e213e9f6a667bfd5b383d52fb532d506acf6e34261c3134b8adfa2df5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc6e0d5eb5465957149c354da54a129563369f36e194b1b12f2a3518e27a208a"
    sha256 cellar: :any_skip_relocation, sequoia:       "008701e745e1eb56933b82ac5d48f6ba6baa9ef5bc5c73b6c10b89a4dcbb8217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a871ccc3fcc37deb1b341f6de42da202aaf23c7bbfc7f51bd31856ac3700735"
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
