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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.220/preston-check-1.8.220.tar.gz"
  sha256 "64319891b545d5e3a24034727a7fb777fd594110ad1356ae1b6681fe0e06aba3"
  license "Apache-2.0"
  version "1.8.220"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.220"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be519a64b214b93b0d4789c2a29854ccd828dc6dce26f8bc0cfe943d4a29a9a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86d00dcd611c54bdb7f72ad8d51f17ae322bd7774e5aa72997d01c58ffc67143"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bde4cef784b945e13f3ab479465ffcc453e1d82125677e51418537a76563041"
    sha256 cellar: :any_skip_relocation, sequoia:       "b97d736bab9be32755bc02a601a5cbf9775341d0d505f98ccfcdc3da9cf1a1b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3998356409cd9db9055f8225e97a3169e2adc2f2011ddd801f99b61ac8673575"
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
