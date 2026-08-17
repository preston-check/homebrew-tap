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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.332/preston-check-1.8.332.tar.gz"
  sha256 "c0cb3b074334279a876dc76e1cda438186fe51e0577d18397f545c7796d9b948"
  license "Apache-2.0"
  version "1.8.332"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.332"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e696b01ead75ac8e750e1fc4429beb0803956021f478d2f0002e47ce35a88e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67d94b26e7a4ed0ff1b671e5fb278decba1008161ad863358e61c63d52584a53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "819390193b19aeb611d1905e271011951643a6ce91b99bbbf9c94742fad66c94"
    sha256 cellar: :any_skip_relocation, sequoia:       "828791cbb093be582af8b147e9a8e8f4985a82c291d5513e270969be660d4148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "954a4c0cb2810e974b189d3672943d258f94baafb851574b89c852832341b752"
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
