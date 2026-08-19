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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.345/preston-check-1.8.345.tar.gz"
  sha256 "cb1018a99244897e684c317d87c7b319c96cfa9f2cc09127b288c3c7dd717bef"
  license "Apache-2.0"
  version "1.8.345"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.345"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5beb1d73b4380efc9bf8c5d02747f5fd1e0ec1a0e207012dd63c7d0ba2f7918"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "919d868c75ef155153213be0711b79da7b2acf7a5a7a2b84d13fd04466017267"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05f71989a53f552c753b53d44d86b0ae94a1a8f6d2c4eea3c206c91298381011"
    sha256 cellar: :any_skip_relocation, sequoia:       "1486aea8b92c03440eeae2c808f90bdaad9a9ca8730f04761d4dc79a5b0d30d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e222e53f93a03c8eec3feab1c12aebcd92d22c743ccbcad796393575b443c4c6"
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
