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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.355/preston-check-1.8.355.tar.gz"
  sha256 "161d45a344a2d589cb04b71436c16fa8128d76248bbb6113d74e9b779a9ba192"
  license "Apache-2.0"
  version "1.8.355"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.355"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e034341a4bdd5f6f37a35a7efab3aae6445c6b5ae96c377ec0b251e41beb3aa8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5299dd7459d5ce346ba23d7ec730142d19a32100b307378956bc0df8fe10a2b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7bd1bf3ac4a7cd5c6840d3d0308cc25b0a26875481baa33ff6558573e4aaede"
    sha256 cellar: :any_skip_relocation, sequoia:       "472c85eec2d5b4678a90c72ebb24a44186ae78587581c3eb941093845ab7b1fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "401a13fecd8310c68e4f07674bdf3a689e5cfb6e9e7a8e74c38167834a2089a9"
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
