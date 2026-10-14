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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.548/preston-check-1.8.548.tar.gz"
  sha256 "5f2368a8e4c280f4b54ee0d77eaa309fcf89b305fc5a0576c11bb228861abb0d"
  license "Apache-2.0"
  version "1.8.548"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.548"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "574741b4b0b590d7fadf63515716d7c030a900ee19dcc42fd87bb41e2971a30c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a01b97a9298e80e1180c601a7ec8246182402d7a0cebf31e2e5ff59e273d9c51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27803a0ec143d299b5834f193bd339ad426abb7fb352377d74fe95b0a6c6d1bb"
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
