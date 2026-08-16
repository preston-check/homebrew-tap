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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.316/preston-check-1.8.316.tar.gz"
  sha256 "ed4360657bff423f043c397c070acb94bfd4005dc438837fffe3c3b8d7677aa9"
  license "Apache-2.0"
  version "1.8.316"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.316"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed581b90904164d853c7b0c15127139156f4824f834de9072a9f1a968740e4a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2968707df48be4733251102df33e06edb5766914e03b149a9797db6ad00daa2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b816ba475fd2e36cefd24d1ad459ce0dab5ebf3edd7d122a4f36e15898ff9667"
    sha256 cellar: :any_skip_relocation, sequoia:       "acb66c40f9e3c5c0e917c356e2a4f7136fd42bdb94fc5d3dffd8b4ab78ff258e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76bca297ad5e97fe91a75686e7846d50c58faa8959aaffc3b96f15e7974733b1"
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
