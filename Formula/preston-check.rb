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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.387/preston-check-1.8.387.tar.gz"
  sha256 "08f4037eeac4194bf2c212d57d33179c8d94c6aca6198f06c678268911b12310"
  license "Apache-2.0"
  version "1.8.387"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.387"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b4bc079633d89611e75a6f6492dddfdc1127950d62f41635083326b49d292dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4aaa6dde513efd70ec896d704064b61e579c887342e637a46e07c73b2d623829"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f02d59f0050174135913a10620c65eb3461741225d19a01911eea20c93c8092"
    sha256 cellar: :any_skip_relocation, sequoia:       "5a947d3cdf694dfe30b07ee00c7e09f966c4dd5c86ad44cc354f70a6112cac05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c75dee1faacc825a59fe27ef46a693b06f3a5c527b30b87fab46efe08777fda"
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
