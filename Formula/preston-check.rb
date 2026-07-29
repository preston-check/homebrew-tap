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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.143/preston-check-1.8.143.tar.gz"
  sha256 "d76df227bd0be782010d4b28767749f384c8c31ac1535f6f7bf13b374ce9e2f5"
  license "Apache-2.0"
  version "1.8.143"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.143"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63bfdedac411220090f0a11863e09a4066504f0cdaa444f6ece5e3fccc890544"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c7d232d4bde50c884e30b55a4ea350fa7938293ff1c94a1ab73dd104f4e1739"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ec239c4310642f2e443eda162c86ce4f3c2cce449542cc19ca49b2acaf50402"
    sha256 cellar: :any_skip_relocation, sequoia:       "822c50591b9684cf25da5a841a86b0ae1e8a96650b2313d11382767c168ec46a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f37faacf734e8554b368551ad50c827a55993069a965725b565815f5fc2c9f6e"
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
