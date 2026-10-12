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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.539/preston-check-1.8.539.tar.gz"
  sha256 "0f24d274898c21753e6614d723790c1e71676583e70638ee436c3b1fc05259f0"
  license "Apache-2.0"
  version "1.8.539"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.539"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7159062d9329457bc617624af09ffbafd107f42f71a8be243de79ff49414b5f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de269cba8af7d6cf8e4d528738553c376560425c3abe933402a11b6d3f57d9df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bb0cf96c8bbe22c0b96c53f1072a38327a0ab717a68a73d7d2ca985f2f9fd8a"
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
