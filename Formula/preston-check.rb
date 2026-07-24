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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.93/preston-check-1.8.93.tar.gz"
  sha256 "0cef3da830abb90037d4388605411eed421bfc7d3033cfac2a2eeb2939a1fc19"
  license "Apache-2.0"
  version "1.8.93"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.93"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ea0c81dd142db2488bf6f8d0616da757d91c8141b9421dd7714b88b6849da83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc121a516b79a7a65c618a22537be4804057db2b9eb2862d5b75c96ae454992b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22064a9ee6283b889072f73078dcbf50596ef663b9506d67838dcba89994b061"
    sha256 cellar: :any_skip_relocation, sequoia:       "e7941cdce0bd2edfd4d9e97513b100ec654c73e589936e35fdf3a4a8ad3182d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b3e2d6cd9e088a320c1ed18747cd80eab2a93b6d54888a931fb6fd2be7ae3c8"
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
