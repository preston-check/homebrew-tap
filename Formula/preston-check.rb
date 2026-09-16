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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.467/preston-check-1.8.467.tar.gz"
  sha256 "3df2876dc7786aca327a81c0bfecb4a9feb3d3b8bb7c752e799c3cffae1b2ead"
  license "Apache-2.0"
  version "1.8.467"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.467"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03f6d3ca044650b1dc87139b2cd5c3248cad41bbfd42dac91258ff8d19c636ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f2081c93237d7a94ed4f6d2dd1e71e328c8d12e7b8fe5c3d01b9b767eb82cbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5b9650f255fef4b4653aadfd93d69bc9ebf64658387086f5620c9450ca9ebe8"
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
