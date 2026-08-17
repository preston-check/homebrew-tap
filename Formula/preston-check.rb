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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.336/preston-check-1.8.336.tar.gz"
  sha256 "e728364e62fcee748988edc945741ca6f7ebb27c832b97e65664f9d9c5a541c0"
  license "Apache-2.0"
  version "1.8.336"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.336"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "244cc564ef695b88915f85d2fccf8efef25cfaf53300a214b58651e8550a8dde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec2dd67a8e72f53b3334910b8df24a56115cba52450032c5ae57a9d0218abf40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4d78a5192b7d024154532091fd1b439350fe5548da0b68971435375bdaeea16"
    sha256 cellar: :any_skip_relocation, sequoia:       "10d74ac0b494ba315b9471fe52a7a510b097c32db5b569c98f9bbf53a902f5ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1b420f7c971dd243d310aa0a099248e1a1c31557b0fda970ad4e0b27c6e9489"
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
