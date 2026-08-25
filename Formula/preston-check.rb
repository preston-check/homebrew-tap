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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.397/preston-check-1.8.397.tar.gz"
  sha256 "2cadad7278a7560829e32e069dd88356c5349d07ce2a26e96d6d9235fbbf343f"
  license "Apache-2.0"
  version "1.8.397"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.397"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c75c6b08ec620f97632dfcc3b30e1c36be839912627b5a5e373e4944674e6150"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd2ced196f19923b2a2644dee480a128d704a804df5f2f5178181524022d9aff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a32b70e0f33f58c2a212fb8ab61fa52ba0f0158f2f9cb2a338c239f4b91c620"
    sha256 cellar: :any_skip_relocation, sequoia:       "aafdd1cdbcae42aff76b592b508cff0a051944efee91f0b7b07465a8dd0e9ba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b021ff09d45106c0eb500ebcc7dbbce99a1dcda8815356d5c9c9cb6daf09eac"
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
