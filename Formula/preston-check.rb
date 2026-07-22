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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.83/preston-check-1.8.83.tar.gz"
  sha256 "f049e5bb11e293766bf14fce7f1b2a31c0d43a8fa74de62a451a48cb06a0de19"
  license "Apache-2.0"
  version "1.8.83"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.83"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e15e7a2c3da67f42d356b315d63933b5dec88a17fdff785778a9b9530e3f273"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff9ee6a84d91712142b1da5686da51075f3e70d01bfa20c47a3a21cd4661d96e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "919d4f27de62f8dada98a8938bc50596cdad4a62579fb2295499daecb96a3888"
    sha256 cellar: :any_skip_relocation, sequoia:       "11035f8c2de7a3959085e52bba95ed64085f80b63fa4df9c34a35c1f6a9b84fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77d2dba3ea10f79ad82a4c61e7320114d1c8ff37ef7505ff4970cf9844c5d9d0"
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
