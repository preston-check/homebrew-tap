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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.181/preston-check-1.8.181.tar.gz"
  sha256 "d9e076718342e0a7fa8650327750a1d8185751ee9967fa32925d8ee722b48ef5"
  license "Apache-2.0"
  version "1.8.181"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.181"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "779653d2fc6a54249cf59363e1b3db18008fc8a81cadd2a8ce7851a0d917c48c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "296fc4ebf49d9b29710d4b1584eb02c4215fd62bf5be751cd453328e7c22de31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c71dfef0261e14b6251616222ad8e76ab2f8b5bec916699ee3406863263b299c"
    sha256 cellar: :any_skip_relocation, sequoia:       "22c4b64322795aab9b3fd1815be4e0c15907e18e583d5563ac1905f2b42dae1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7273256c4caf849bcaf4ef7a8f699112fb799358ce142e34b4d9bfe5280220e4"
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
