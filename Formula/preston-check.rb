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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.468/preston-check-1.8.468.tar.gz"
  sha256 "29589fa1af541962de2a845459448e60fd95572188d9a953b359f3c5137a500f"
  license "Apache-2.0"
  version "1.8.468"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.468"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8794994a675b99e52f4e7b422f7ae4d4a106403ee8f53fe621a3222394c87c30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0563f98c009009d713db064300a3b121b57f5f63613c4912fe64bacb7aa899b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9376218223142c70ea4f8a3d3127e95786db7767cd339eba82f3110b78c9a468"
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
