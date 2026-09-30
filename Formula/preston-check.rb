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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.509/preston-check-1.8.509.tar.gz"
  sha256 "74f6f987bb5ac22f4a5d7417d2ab61a9d272efcfc1686d7254c74ccc89a7276c"
  license "Apache-2.0"
  version "1.8.509"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.509"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad12cdcec13111e9d22f14c8aebc9840b1d2c3e269f788d406dfcc7d326b49d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38c3e335e03514167498474597965d3eab418316f034f7059caf25fbe2710e95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be91a33b9a55538ead315546f4e5203f6921853de12372d7e092b9992ace88a8"
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
