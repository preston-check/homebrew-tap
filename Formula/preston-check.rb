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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.63/preston-check-1.8.63.tar.gz"
  sha256 "a95475923f0e57c2b18f98d98476c88c98c2c8eae32ff41e08cb62066c6bcbb7"
  license "Apache-2.0"
  version "1.8.63"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.63"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ccf4f4ea7164c75aef5d5209cb4742e865fd5b3548fc922298704758102a7b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83565e6050f58334ef75f9f6da46f6a7413a012c6b35b1298f89bf28f5bd4f87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccd2396cba57b547e6133b2605a23c40655e025b25fc86b143b49ed749ecbed0"
    sha256 cellar: :any_skip_relocation, sequoia:       "2fbb496ea0583117221fb44a4f88c26323ff2d9470de0a2342d389c19faacab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39ec34e1647504dc5725d4c6632c3688bb9be6412d2d4d1a0f15d3134178c26d"
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
