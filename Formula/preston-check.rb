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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.305/preston-check-1.8.305.tar.gz"
  sha256 "786721faf105c43c1286f2b7282947906426055064956277f66ca0ff635f9b86"
  license "Apache-2.0"
  version "1.8.305"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.305"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1174eef5bddd5db7149ffa862b72a3adf0c3dcdb73ac471bd807174cc7989354"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0f7bd1253c99672d58aafb3d5b4817feb945e5c9c55d139aa9c7a6db26aa749"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bfd9f7e59dc837f82539376957ff92896d11854635f8d0f36de90ac98b5d406"
    sha256 cellar: :any_skip_relocation, sequoia:       "0f831770ba4d8468793c76529cb108117395912f940fec15bc0f3cebd6c4ebf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f4fa4dd0a3e6a9d1e58bea10eb1925e4e3a3f11405e599780973927ba6d3873"
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
