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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.328/preston-check-1.8.328.tar.gz"
  sha256 "fd2f0e5a035eca6f482fd33a6b6a4263f7f528fd01d45f862550b2c8664f0279"
  license "Apache-2.0"
  version "1.8.328"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.328"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4cc2991027e16bcf529d653c7a88db5e19c7101cb2628b767ca2ef3930a7280d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cf26dad49eb153cb41b8d1bac67d70739aae7126cfc1fdb9f9889a60eed9b6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "472fe7fa5a303fe973df624f9115e4ba07ec42304da30cdc832d22eeff539586"
    sha256 cellar: :any_skip_relocation, sequoia:       "0ddb3b7c43843fd8a35cf4d35b3eb8c5914e739534f2d119bc7f41184646a499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdd70694ce52549b61a09eb2b255bdb6108e07e349731f4d324d319301f0d343"
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
