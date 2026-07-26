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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.110/preston-check-1.8.110.tar.gz"
  sha256 "f147a79443ff1ae7c9928615ca22688151245bdcd24049ca37c60c84f7634e58"
  license "Apache-2.0"
  version "1.8.110"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.110"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc259d8020df344c68138d564e52a8df5c2498a4deb96d987346c9e52fd93144"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5a44e8ac249659bea83b403013cc6de9918a723ba209f9f8bb3e923a459863d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f247f3fbbc57ddf846848508754c70dc273d5255b4678156a71b9b6e30ce767e"
    sha256 cellar: :any_skip_relocation, sequoia:       "28b08a7c6456a3339f02ecda187c46f90bf5596dfab842c41329e2d262d5c407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3372b3e9c1ba15f0135dd00ef18e2fe0dcb570b9d6aac3a3c1bdb18d612f9555"
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
