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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.144/preston-check-1.8.144.tar.gz"
  sha256 "071af019e43d8f6d8c748f62de2d61f977997d2fa7184d77ac9d84ea5eb117fd"
  license "Apache-2.0"
  version "1.8.144"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.144"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ccf0799c0d8df46a42ba0738feff02be5a9b1bb3bcec3f0729d3ddeaf6f4361"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82126555f83b5ac091523a23052dc502c01f3260c640fb6d43b472d1d54b8174"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1695825d9210bbb00b7799d89a88ff1b8ac96fe0bfb4d1df8dcf0e14e158fde3"
    sha256 cellar: :any_skip_relocation, sequoia:       "bbdd07235c60aca730c79a2e65a53325c88a24831987e667bfc39591e53ef4eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d837f4f0539b968d67d13ab416d974025838808a487601b6d5e885998916be66"
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
