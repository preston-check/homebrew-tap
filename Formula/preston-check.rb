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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.199/preston-check-1.8.199.tar.gz"
  sha256 "a40fe6f389415ed6eebdf27e03d67d82c7990ac3e181c694c457a812bc761064"
  license "Apache-2.0"
  version "1.8.199"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.199"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a55e45e69d64b2096052bae6fd0bc6951f753f27bd214025d2182c5ea75aa183"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d9fb47ef71322561786ed2a0d44a3e88055679ddab27dd03d4bdc1f5092ebb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d661b52c71aff915f90f5aeb60cba3ab3d6f3ebf140a6b535561821009f11830"
    sha256 cellar: :any_skip_relocation, sequoia:       "51a29f7f93a6808ac653a20c3be23202f7e9cdcb62e61a362ea60759aa1cd465"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1420374b08acdb56006efb5519d8fdc6fdca26300d27503f92f01eab9b048b7c"
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
