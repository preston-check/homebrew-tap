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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.269/preston-check-1.8.269.tar.gz"
  sha256 "f2266d5858ba966c4331a9cee0d82738e26048d5d78fdb6bf1e006bac362a5a1"
  license "Apache-2.0"
  version "1.8.269"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.269"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c7213c503e1f43a9aa2abc8e749489a6902a9109d5c363ea793791ea1c6a9e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7039c728226ddb82b42cd530b840fc51d7fc7efa4678abf5b01ddbc18200e332"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5746f918cc6c72b319da4f24f2884d328e2eeb03c667f830bb3fc99b7c175c4e"
    sha256 cellar: :any_skip_relocation, sequoia:       "08e8f0783c3be2f1f4f1f82132aaf776491a03671f06c32c73e9a32f84bd9624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2583ca195bfec114859a793646002e5b15bec7b80b1e7821ca52187c66039ddf"
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
