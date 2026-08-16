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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.304/preston-check-1.8.304.tar.gz"
  sha256 "cf341b573f4b2a0538c60d798943508bdd1b7af2cc0e4cf062d61a616e03d721"
  license "Apache-2.0"
  version "1.8.304"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.304"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4a4f825156e32f8b58fed0026a2bd1154ea6bc9390d1ef49f2b772bbddea21d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "284c8f142e0e3ed214ee0534854df66d87a80e5ba09581dcd2eb52689b7c00c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7e99595a36d1d6db6a9e416bb8b3676983f7c0aeb1c1263b7d589884d6e38fc"
    sha256 cellar: :any_skip_relocation, sequoia:       "50be2e0ed8b19e55d3ee60b6a0c23d319cc220a881bbfd0f537db5b6b72cb580"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48a2be58f06ffc679eab3583869f2684430297ef501372fb4be4513ff44b7caf"
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
