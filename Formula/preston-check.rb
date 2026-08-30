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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.406/preston-check-1.8.406.tar.gz"
  sha256 "6a95b8f783c9f2a03ab3b2c8d7668acd7bc939808105d72b3fec2109461898af"
  license "Apache-2.0"
  version "1.8.406"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.406"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb4446f2ac99f4d3db70f8f1376783529ace887b2b9457ff2c8229d5f3404c0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17506c77190015d5b29896f2331ad4ed501d409b3956afc197e91b8e05cad157"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65d8c640682d5a5fd8dc80dca82867b9d0070d0cf4927f5181ed128c9df8d372"
    sha256 cellar: :any_skip_relocation, sequoia:       "3c3676092fd5b559868a267024d5cf36080a321ec7395df18d2446fb90717615"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d93153647430ae68a76d43796ae93d38aa0b66eca00253b9cd785ee5edb6e492"
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
