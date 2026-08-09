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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.282/preston-check-1.8.282.tar.gz"
  sha256 "36989dfe327f11e5a7ef822725c101686811be674da9bf3588c47f1fae9969d8"
  license "Apache-2.0"
  version "1.8.282"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.282"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b3223da105690e9d901e0c4eea1d5f22c066f0682fb9fe1cc45adc7f461d728"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d5ffdc43f9e7aa08e8b38f582f9c5f93b82d86b3365ffb18b19d5fe34ec3540"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddd0ae3845c05b0598828a01e66c36b376dc92ab801b1cd6588427347405b611"
    sha256 cellar: :any_skip_relocation, sequoia:       "4ecbfa6dcf11ef50ca6b3e16c1be8a2d3bb78f05d2b1f3158fe3346c1de87cde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e425241bf769b62686bd26266ebef74b43ca2d1f5803c51e7511701617a9b75"
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
