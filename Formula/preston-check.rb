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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.402/preston-check-1.8.402.tar.gz"
  sha256 "3ebe1c87656473cd07aaf41dacba84efaee5736f5e8b33b52cc701615b05ebdf"
  license "Apache-2.0"
  version "1.8.402"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.402"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "906053692b523120145c6496a5d5e8653cdde1b07e4950d40fca02eb5832f4b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "638d2e239a3cbe8d6d9a7078b2c7dafa12c404d26302f3e27b5ca7539d06daad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "521ca39414a09ed269da23c0aef8ad00980b7a80bc555dff6fcd920db7f60850"
    sha256 cellar: :any_skip_relocation, sequoia:       "c601841bbd03ee98b34126315b1b793ad5ebada1b6c724141563a201fa824185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd6a20d75cb6d1913ec8d8c3c94f26e19722bfbc440f6030dafa79607cd55cd1"
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
