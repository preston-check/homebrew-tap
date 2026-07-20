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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.68/preston-check-1.8.68.tar.gz"
  sha256 "1f909ff54a665cd6279faa812f7cf1638d5f3d4c0acd1d02d32a821682dbc462"
  license "Apache-2.0"
  version "1.8.68"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.68"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa3af1c1202f6ba623cf76ca52d28c40bd60454d0a65df598854773ab39c20db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a0c2e04793729160e1ca7ce1353d675046c87c1d01cf3245e30b9a9bdfa4be1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb13ea57a2ce95788c4ebf92041e644a06ec11f718ad5f903c51827a775b742f"
    sha256 cellar: :any_skip_relocation, sequoia:       "37779598cb74c92fb4a957aac0b6906133d98a6e6e898272a6b91560ca0f55cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d38a3a6a71dcaf052c55a36d4d34ed3e265a0b7f198d0261f01af67932e3ce2e"
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
