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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.399/preston-check-1.8.399.tar.gz"
  sha256 "6bb98d5e996a4934ad1564443ff42065e5fd8b6fe0e3a379425320cfbced6811"
  license "Apache-2.0"
  version "1.8.399"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.399"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bcaffe2b7c2a8e71a91f83d42d319a4df64ed29e5973fc2b2deca4a2fac06d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f456cc9686f9a0f877885c4ee100efc6055e3085ae8fd63b2324790bfcb7dc53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "785085d83ace30018c1505d3c8374308bffe02749cb3520b28fc0382434b384a"
    sha256 cellar: :any_skip_relocation, sequoia:       "3b747baba9f4312d5157f92518e63828535eeedbe6418d8f3ef7c9be445812e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8fd340f1badc4c828d1b0d85f184916e1df8b4a1381025013ecb3d93b45cf0d"
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
