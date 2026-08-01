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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.176/preston-check-1.8.176.tar.gz"
  sha256 "2eec0b561d801c123005ef16e3a41c0d3aa8aa5a766ad10684a94fe4ae363dcc"
  license "Apache-2.0"
  version "1.8.176"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.176"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "336d09e79a26bb6938b72b9c4ac999002d5a8b08373600f65b822857c34a2985"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ce3add8759fe2cc4fd83978408db70219a6cb7e13e5c9cac5bc1a10996d479c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb71a2d0a7751ffe7783d2d2862e26b6e9e4f68d185299b88b738d2edde4084c"
    sha256 cellar: :any_skip_relocation, sequoia:       "2b5f2e6dd1af0d2bca04b4762c509a2681859954477ff5baecaf45856c91ac9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e663af5141c92f818e587aeb5f45eeea1ab979c298e88456ecf55f3420706201"
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
