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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.30/preston-check-1.8.30.tar.gz"
  sha256 "b263fb14c6e7922319771872542dc11dae0d52623c2fec7944572a2b49ec0dbf"
  license "Apache-2.0"
  version "1.8.30"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.30"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d785ce060dcd16bc50a8c36aa08a00672a2955ad28f1033adb8db54221ec6b2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0372a53c838a31d7ab9a089c37b47a379e125d60cf63ae113dc1cf494823f75b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97da9922ad01ec4cdcdff3931d013cca083eecccee92b840cdc1c614be1f0ecf"
    sha256 cellar: :any_skip_relocation, sequoia:       "b7aeb3d1fedcb7d26f04aeecf96e0e42703315748fb9c96ae41dc64a8f306a06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9e80ba374c94062a9b6b8543c9c8b64810b8487a6c9af10f15e49ada2c4b2ce"
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
