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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.281/preston-check-1.8.281.tar.gz"
  sha256 "0ec808abb0b97b4f3b131c4c1a8f600cc88b8ebd71404867ef50ee75949e6f07"
  license "Apache-2.0"
  version "1.8.281"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.281"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9826837440eeb0fab6a9e4ed992dcb893bac7f24307934cc4001a436838f6289"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dbae7f131f013c34ca5c6ffacf4350cb7f81e8fae68ab94a7949d1ff6d82d5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "265a9e000485be269456dc05dc1f01202e0706a7a571397f7ca4fd406b2b4718"
    sha256 cellar: :any_skip_relocation, sequoia:       "6430f83f9adab2e473b2672462753711a2a064b59c66ad0ab806da9017d1d5d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28a1b24dc13e653f129efbde76e05d0e2fb194d7facd6d9f8ff0d9be2164cfc6"
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
