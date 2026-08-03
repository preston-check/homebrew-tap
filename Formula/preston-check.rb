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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.200/preston-check-1.8.200.tar.gz"
  sha256 "98fed34aa5bb6c998c8f57762a990f4dd79fc005465f18827a04d95816f68b56"
  license "Apache-2.0"
  version "1.8.200"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.200"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d25255f260ce46d29bf96ed31aa687ef77aa4ae997b36436afc338890d1cff5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dee58633b9920ac9e950fb221c386c1a72d6af1b76cf4977c56919d43b6c2c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c91279d5952a4f97e6bad0aedb87ae140a677be588c2e990db897cfadcaf9740"
    sha256 cellar: :any_skip_relocation, sequoia:       "6c27a8c35aa20a4a702f0f58cb2214b317f134489b53c78dbaa0b5b5c4163a17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84de2d3d6e296b91cd7af2941bed38a4a12815566a17470e5dbfd0c73b576553"
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
