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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.351/preston-check-1.8.351.tar.gz"
  sha256 "b44e9bb7ca4946e199a83dc8bf1d66e80091e04efe26678f96c03cd7824c115b"
  license "Apache-2.0"
  version "1.8.351"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.351"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb21b5d8d3af4cd8796fe68f3e241ead87b2d1ed4d612f7117e50f23cbb9890c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5f017d440247ec2bb258f3a7df30364bd58bb8ae4828194729db2f9b44160d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f31af734d9fcf0592d0d81e807a44fd2a713bba869457d15250aa2ec36b64d0f"
    sha256 cellar: :any_skip_relocation, sequoia:       "c138c118b4cf6381ae13def1565ae84404307ad528c981a1bbda4763fb33dabf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99a202c9ce25a585762ad38fc7e0480aad0c90af9c8f270a6e730644fd65ebab"
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
