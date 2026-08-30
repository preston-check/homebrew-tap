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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.407/preston-check-1.8.407.tar.gz"
  sha256 "acaa96aafe848d1bec85f10259b00378b89ee82d17debb328a18a4aebfe755c7"
  license "Apache-2.0"
  version "1.8.407"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.407"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "611745c1fd9b8e74de6877860424aa55fc6ae3db7e6e32ac3a441d12534425c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c40e8be5f6b760e792862316743879d2be1dd5e0edd2432c894d3997f5505be7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74d0e345c15c86d8e732105fbe086f86d63427767bb4d3690fafe92fd7018f40"
    sha256 cellar: :any_skip_relocation, sequoia:       "d9491cf6ccb4eef9271f90801d6373ec638fdead1e31abd5aff4e9d0ff1548ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a02262f37d704f4e47d529335b9cc4eac56aa53cf47b96ea0e9924083318e2aa"
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
