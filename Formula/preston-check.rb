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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.102/preston-check-1.8.102.tar.gz"
  sha256 "c9de942c09e32a3bcd08fc28e4a0f91e074b89d98fe4c7e2af38bccab6390297"
  license "Apache-2.0"
  version "1.8.102"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.102"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff1bb386bfc7ad4cdc963040531241c887db7423cf90f8a6b9f932c7c1b0ff5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26426ab169aae5e5d7fad2a5e04789f0d3588baf95fe8c2e0eca61b5b073e42d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a2bd2e4f8326a5ff1bbac11b44900f84bdc9cf3531d7790397cabd01210783f"
    sha256 cellar: :any_skip_relocation, sequoia:       "6ee8d06d35b3b5e875b260e89e7901ee31035e1387a64087b504076b0d434014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ccae7c7ed7d81e40fb9dfe81f2e7f04f857ffad11706d243d6eb80319f4d1f4"
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
