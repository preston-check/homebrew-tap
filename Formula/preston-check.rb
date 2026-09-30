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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.508/preston-check-1.8.508.tar.gz"
  sha256 "d3e97468980d3346dafe794d48dae9dd47cbc039f421fb1fc9b11649b09b58e7"
  license "Apache-2.0"
  version "1.8.508"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.508"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "841431dd7113a5f1a83baa3c9d6a5104fa285bdcd05fd359a8b530c2047c5280"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2aa15551802608cc7c5597b2558a0cd32a8b7a44b66f2f4ee6b0b346cac76d25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e58a38eef455fe660c23aced663437d1575b419237876029297efe614a4cf086"
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
