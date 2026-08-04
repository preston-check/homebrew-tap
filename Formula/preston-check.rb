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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.208/preston-check-1.8.208.tar.gz"
  sha256 "6194589347160ae6aafab6b33445548381db05ac3a86f37d0b7558fce47a9c38"
  license "Apache-2.0"
  version "1.8.208"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.208"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5decec8c5fc1913b31c6794de03116ac61f23d48b17aabc20bdd3133d9715c38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dc35c31358230ccacf6f42fbe7517a84be84c0c07efb769b6df8fa34020bacd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "522fbbaa9a1678675b16fd5c41342d9aa2de394e4b73c873f3c6b625767b84d8"
    sha256 cellar: :any_skip_relocation, sequoia:       "de32f4c0999e275e0e25efaeb9775a288667547ba9aac3047a4b4861df7187e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8150f6d207d24c78c5616a8d7245eaf1c88a90ec2805d4621f668ddc4f72df4e"
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
