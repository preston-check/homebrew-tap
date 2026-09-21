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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.494/preston-check-1.8.494.tar.gz"
  sha256 "b562cf2dec4843a86209a1ece363a3fd44e5c8615103e60d1e34218d559c2f1c"
  license "Apache-2.0"
  version "1.8.494"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.494"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a5f859598da35a7b4c9a4ff8d4619688bf1577b192834cfc14961e633364770"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd06907f9ebd1ee2e4819cb22408fa23033ee7e15b74a9a2cf10b48701bcf50f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "417b9ee99e3b6bc5e1c5e720caba6f5c17d08f536ff2e534858c5eecdbe02c88"
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
