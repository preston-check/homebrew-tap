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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.480/preston-check-1.8.480.tar.gz"
  sha256 "631e158d3d681bf5f344a6f6d360c880a8a5ca5087b9c133db5e32fa0f975f2b"
  license "Apache-2.0"
  version "1.8.480"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.480"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1479d9d62f38b4a110fa139205a31a5e8443f6dd7c0f82a478b9c3248f5548e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f04e6ae646a8f2a476cdab2e594ce02331e7d5871d87425c0083c103b2df1c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5be2bd792f7f17ee664080dd948e725b3208d30753fa0460870010ee664a235a"
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
