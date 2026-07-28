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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.133/preston-check-1.8.133.tar.gz"
  sha256 "c1046f7ece82027136ab350c332351e1747af2703db4f4f4aba3860a5cb520b3"
  license "Apache-2.0"
  version "1.8.133"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.133"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa54a7227b3c4b7a2d9c0bedd009f41aed562909b355c1a4604a031929549cfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd508cb1fbed285be1a97e69390d31e0b777692ff7813ac815ec7bfe5785f65b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b7d21339410b6401c01385f960483bddafa6141f1218e96190e1bdf40c0e8c0"
    sha256 cellar: :any_skip_relocation, sequoia:       "32fede385f748a43f28c8be4c504269c4027f5a1530c2f0a20b1532e5fc31ff2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b2d1060cfe55475c0393d73107596ab542c00e3585d14aad57c68159d468117"
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
