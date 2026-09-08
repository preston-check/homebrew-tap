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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.428/preston-check-1.8.428.tar.gz"
  sha256 "afc959e80d7aa63ee387304c55c25981c737e4fb997114a439833a86b97921bc"
  license "Apache-2.0"
  version "1.8.428"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.428"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23bc4beeb1b825389ae17f119047f2c002ff0f68b1425f7ddc31e70bd332905e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ad00d618e34a2040d1c6b52e9d37827b14ef26339f7ab582fd2228c8537f76e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60599657839d0cd42260a882e1112629c600e24be87234b4171300804a7c8e8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fababe75ae7d7d1dd6e535bd6e2df4dc034c619f2558afb45ae56b97c7c367c"
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
