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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.279/preston-check-1.8.279.tar.gz"
  sha256 "cd4464d5004969974d3f50f7493b258cc79bba3f982642b79d3b44b99aeca3c8"
  license "Apache-2.0"
  version "1.8.279"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.279"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23bcc5192ffecfdcaeaf15ad9a66ba6c513598e6e2dfd3a57bd0ce83ec885a2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a37efcfcf236d11cae3c4f9487f1a8051ca67f80bc2421abefa9ff47b8786dae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f03ce01d49a48a932ff79490c43395421f20ea3ac5629f4b4df1d12f83f7e5e"
    sha256 cellar: :any_skip_relocation, sequoia:       "3ece5bf1ae91340377e0908afae06b43431b505bbe6f2e6aa2886e6e7cf50db2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa15ca4658bdc156e4c52f807e46d682edf7ffe34c03c506cb75696dfdf4dbe7"
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
