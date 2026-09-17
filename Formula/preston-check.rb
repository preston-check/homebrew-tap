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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.477/preston-check-1.8.477.tar.gz"
  sha256 "87271cfa84b86b042ed689b5ae91bdfd0bed2b11220fa36be904364d36d382bd"
  license "Apache-2.0"
  version "1.8.477"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.477"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b8f912c895b876bb4c8f1560798caf979fa0fe83a22bec79954bd225802ca8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1b2ed6433d747e23d6f0581e6449815a7ed2d5ec62a2c581caf969ba2cb5301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0eb12a4f17048af08d0115139d95a7a293fd8e2d66f0b9949ad9a83c412b1f38"
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
