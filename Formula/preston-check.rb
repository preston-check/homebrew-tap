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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.217/preston-check-1.8.217.tar.gz"
  sha256 "67e6286eb30ebf58633eccf3526706f3216f0a5f485843cf8ff94bdf5e960179"
  license "Apache-2.0"
  version "1.8.217"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.217"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73ef78557ad88ec2abe89d38a73377373ac40918ffc56278d845a16f26b8dbec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c36651c809ad6cf0de63df684d3f5fa2e28f0c1b3f3638fe3822264fef7bce3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c47f5d32a3671f81d5a6f9ed6f91cadfa90bf573880aa59988beaec976a9401b"
    sha256 cellar: :any_skip_relocation, sequoia:       "8756558050ed5e876b1256fc6d28704909ce6e220cb8addccea819df077c12a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7048e639e5ea55be07a3f30f8cc42c06aa70e9c94d5f9a1c0a146878f94e47b5"
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
