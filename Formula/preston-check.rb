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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.385/preston-check-1.8.385.tar.gz"
  sha256 "83b0ab94e02e41ade6f8cf278efc2bc3b6ced7dbfcd084f9f25749f227d2ad2b"
  license "Apache-2.0"
  version "1.8.385"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.385"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d0725048e22e84632b62eb2cfdeead9f15be0462107806edf371a7e7146a555"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b0b36a30c905ae1e9152264ebc357e2b7c90b4a0114fc2a16734cbfbb8b3604"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3bf93206b0a29a76ebf776f6cce23ac5fb53b0896ac16a5b4b950cb2e958014"
    sha256 cellar: :any_skip_relocation, sequoia:       "66299d6ecd786ee9aed39bd6a7a417b301698acc046944aba95eae31970b43aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46066d4b4a3d356939f2f9b73e4268e5e3932f7423576819adc2c044bd73d223"
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
