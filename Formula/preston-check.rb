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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.561/preston-check-1.8.561.tar.gz"
  sha256 "c6a216828b57628e364ac6efe811eb40a9e66ec8ac6c2438f55c9f0ae3afc83b"
  license "Apache-2.0"
  version "1.8.561"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.561"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2459fb7f97e2ebb0f5d691223086e4c784d595b6d00592755cc5526da46275c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b98e006c256813dc68f038f48e5758bfaa59d7b213940a8e9d7e3a58ad6738bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f14e1a2edf8b2a03c4e9dee8003fb8c469563c8bc9e403fa0636ae8f1a5dc9bb"
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
