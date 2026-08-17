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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.333/preston-check-1.8.333.tar.gz"
  sha256 "468217db7e2d42959b70ff2e308cac9b8ca332caed9cda71558d3dfc24042ebd"
  license "Apache-2.0"
  version "1.8.333"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.333"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fe57ce8a63ebfb6a9f5ce5f1e83b736cc987ad0e3b04ed5057c62b8dc9e5b16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5c6f9a2b7ae6a6c563b1b995ba04e7d3099536f89d95b5afec2785a9913b766"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6500a1536e7677a83310bb249b396a3304c95879b3caa1c98fcbc63bfd52f29"
    sha256 cellar: :any_skip_relocation, sequoia:       "f9cf00548bba52af43e157ff48bbcb1f3db3b6bd6760c88c6c6407dcbfbc8355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "611d494053ca8ed312c9d05b1781eeea62facd1b990a11f72e25884beaa4912c"
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
