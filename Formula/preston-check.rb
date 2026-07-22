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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.79/preston-check-1.8.79.tar.gz"
  sha256 "52bd07c1976688ee17b11b6a236c9719a0a4c2c3879acf6e7644a62617b856c6"
  license "Apache-2.0"
  version "1.8.79"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.79"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf99234c1cfd52b26a856460d4b1c52556b64b32c8b76c3b7d32369e600cac9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0922e20d0a3953c6996286f6282f0414253c9f90ba13102be3740954afa31539"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dac5add4753ef666937c19afa976a5deb0fc82ebc10b6f447faa4657c582f9d7"
    sha256 cellar: :any_skip_relocation, sequoia:       "2f37d7e8640a3940ad77048857a749fe158ec7e8a4a30af48fa5887188cbdeb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "610dcbfd7441280a7c497a60470e17ed47d8226b7d0fce8ef008a66792248612"
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
