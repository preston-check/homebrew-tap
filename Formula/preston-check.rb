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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.373/preston-check-1.8.373.tar.gz"
  sha256 "58d3562cfa86ebe5283d105db81984f0487b88a3e64df18fa2b61ab76acc3055"
  license "Apache-2.0"
  version "1.8.373"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.373"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63126ad4e3293d386d528ac114a8b3f0875ccb3d1ffa0fa2df9bed8ebcd3fe4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff6c20750e8a0d7cf5324c31e7987a2ea0dccd199bfdfb6d83a68d89653910b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bcaf70d266238bc2d1cd7500d0db999b7cc0c2b021061ad4d172f398fc5b730"
    sha256 cellar: :any_skip_relocation, sequoia:       "d911407161fabae4507749ede5dc701ad2e29aaf86d49408f049f2e23e269b03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "699f44fc95993595d93c48ca7b27be4cf56249573ef101e28f9320d33f55e018"
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
