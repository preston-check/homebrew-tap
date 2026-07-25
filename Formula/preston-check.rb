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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.97/preston-check-1.8.97.tar.gz"
  sha256 "d94a0ceb9eed88983dcd3017247099d4669ecfd37ae7ba9524be02548d183abe"
  license "Apache-2.0"
  version "1.8.97"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.97"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1ea9ce151e4395c3f2ff84bcecf6152403261ed29761e52019eea924cc4c3f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "858b420132403b8652b2eac14f6b285b4b04d2fd5860ed5608922b633069811a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b5114b90c8bd0d91eb336e6e7af27142b4a2f260a04f5f016c443ce8dcbf53d"
    sha256 cellar: :any_skip_relocation, sequoia:       "b385207468018af9aa043c17c23c2ef9ee2030c5f39679a0153912f4be87c376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "801bd424c7ecff1e0122644e7d9d0df3031904fff6b433207bd1048752dff4cf"
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
