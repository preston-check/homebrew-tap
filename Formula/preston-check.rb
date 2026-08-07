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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.234/preston-check-1.8.234.tar.gz"
  sha256 "a5691245dd42ff00421d932c8c595c8e7e49724e1d13140e5996fa6f08e5671a"
  license "Apache-2.0"
  version "1.8.234"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.234"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcbfbf0580ae4cfd7db2cf1c8c7803d8624e615e595ee739d62a67153a0106b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d566f9f6af284795c8cfdba9ffa2657322278b0d1b770f8c0bd42ca4a8980f1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7776002c455ee7b1ad61695abce898f8ea7cfe67e06feaa81f7a221c412f1b11"
    sha256 cellar: :any_skip_relocation, sequoia:       "823c84b3b1e9153f2841038e27d0a3733ea073cc54685f5d2a49214cb8fbd3d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80ccec47621a5c66ceb9b4c204a11bb9a0c7bde8751a6072e9b3f1c433bae472"
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
