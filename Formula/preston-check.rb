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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.317/preston-check-1.8.317.tar.gz"
  sha256 "85c0ae6ff38864243ee9a10efd9b843c895f046148df04b1340e2ded06afa935"
  license "Apache-2.0"
  version "1.8.317"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.317"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47f05300e37db28cd1398fe68fdfd56535aeddf20b30d4b35cab7e5214baf2df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9af68aa50925580a2db9d9a7bc4f7633487e4921b0efd47974a464e77c883d0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e13c7d56111871d5b44a65678c8840ede6fa9dd8a6233c7d2c9a0521aa99853a"
    sha256 cellar: :any_skip_relocation, sequoia:       "64e21ffd0567fd6e85801daf2b550b291c733d55a4abc8f2aad7b554d64ebe1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d0e78609bdf290480f69af4bd697df4d724d416f70a13b8be94712f01c0ddaf"
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
