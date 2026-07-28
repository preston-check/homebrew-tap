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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.139/preston-check-1.8.139.tar.gz"
  sha256 "2328affa6ffe4f79229aa1c82bcd35e010d2ecccf299e245a110ae3f1ee9def9"
  license "Apache-2.0"
  version "1.8.139"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.139"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a852f360838ccdd75f568ec9222e28bcc2dac1b0561556faaff22e05ddb5d5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "290c9e890cdd8b87bd1ba99e7792d9b9d359c758b7a1f08dc26ee4f0bb76cc5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1982abdfb69abf46c6007a1f73a1bbc7568b19eac3acdb9d9156a289ee96837"
    sha256 cellar: :any_skip_relocation, sequoia:       "d494bcb299d99d48136e26a30bf76a5e0027da196d632f766973b565ff9f2e2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8ab71f09f832187eb4a5a258bdd31deebe348ccd02f662865ac4469cacc325c"
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
