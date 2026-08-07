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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.240/preston-check-1.8.240.tar.gz"
  sha256 "6037b475a26cb168eee1e827f15832d97b10dc7c891a7a5db524d32a527f39a0"
  license "Apache-2.0"
  version "1.8.240"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.240"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27bcffb769b4caa837d20e5408f0f0879a5974709f64ef817beedb282320572d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da79e8aa146f109dd60349e9cfb834b1e7aaa81f15e2eee02f9a20c23906abf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e582e6a6d5bdb6c24f96039290422d9a0416422643d8e58c1a8c4dea1d717536"
    sha256 cellar: :any_skip_relocation, sequoia:       "901c99fd419da56de89144b462beea0f7d3ecd8cd6d671ac4169896bf8ffee52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42a395b8e00c1b7f15192d439696376e2d9871c73bbcfe3b7a6284cd731ce9f6"
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
