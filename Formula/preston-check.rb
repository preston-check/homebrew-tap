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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.340/preston-check-1.8.340.tar.gz"
  sha256 "daa7ed2c719ef473fd8133a210090ea4dc334c9281baf58463c29f9edcb193a1"
  license "Apache-2.0"
  version "1.8.340"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.340"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e039bbcb974751900ad25603f8c955f4d7de9ae447beba4d33945604659ce75d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05950967931d5d93d8b7119f68066959d6d2ef06b1ed24252078711cf9ffbcd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01bb70b94999b3f1caa405b2e71b4da9c3989ca7c9e15884ca9f2f9434b04368"
    sha256 cellar: :any_skip_relocation, sequoia:       "ba89f95a4448627af7f58d556892e67bde9f9ebef1fadd72ca291368ea2d16bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ac91b5c596be7769dc365b627c51b5f82d13e0381423e1e2b743f8db6d685e9"
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
