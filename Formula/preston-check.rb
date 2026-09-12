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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.448/preston-check-1.8.448.tar.gz"
  sha256 "ca09ea47148cd582df0eadf701c0f1f27c4d3292721f4b7054d108e33628a903"
  license "Apache-2.0"
  version "1.8.448"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.448"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0250249a64dde63b618eae5c949ccac80b6b1221625bde82a99e141450f767d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efa85ffd8e91474c53ec49a4f5fe0fc34cbbc31ac36b72cd7a4c2ec89f7d8657"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f69d88c9ca8d6a1834d7ab270c0851f11334abf1631f7b9aa17f2c4846f22a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5eb94c87d8752bc9941745221f18ee11fa21ac95858d7c753cc981fec6fef813"
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
