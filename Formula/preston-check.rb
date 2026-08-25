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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.390/preston-check-1.8.390.tar.gz"
  sha256 "8e86fc373948431306d1e4ca6218eae9c601f25569477d41142736b880932c57"
  license "Apache-2.0"
  version "1.8.390"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.390"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36da89e8a797e82de67458dc34c848fd6784294bdcd3cfedb1149674dca4ebf7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8e7235c33296c76a5635639780af9d0fb775c47ae3a57e2c9db833697c02ffa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e25232d41cc964dd6a5de17b16e83a8654c102d76ea2589279ed7ff35ccdec5"
    sha256 cellar: :any_skip_relocation, sequoia:       "dd0524cf0d34eadb2381812bcba099e37ffe6843b4695fdf34508d429849d380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea3aa760caea52b0b1ad291f000277d392c3481dfbd0e1a5f15db246d23c2cff"
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
