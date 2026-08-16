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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.310/preston-check-1.8.310.tar.gz"
  sha256 "9e96a7d8e09b69fd0203d6733601d45d80a50800428b827351267bf754ea912d"
  license "Apache-2.0"
  version "1.8.310"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.310"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5054480a7fc89169c98192780e3d6c394a8de7d2ba932481d59ce9349c879d57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "841cc5933a4c4989d1ff529fdd38cded482d80cfd2f5a39765354ed76afab436"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee0dc85664968c42206d25c669827fa952eb6a0d7888356f66c2157e34bca436"
    sha256 cellar: :any_skip_relocation, sequoia:       "0b475189c8c2eb0c0f2f2ae58878720dda3d3086fcb4c549a09f49c202626481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ad127859afcf385499a529bbfee60a023d8c69335121c37c7f4f62e299500e4"
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
