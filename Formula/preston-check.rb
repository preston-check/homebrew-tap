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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.398/preston-check-1.8.398.tar.gz"
  sha256 "0d908b3aa34bc1cb5e22528a1d43a0d88b6e13cc8ec918c1dcab6a06b797a595"
  license "Apache-2.0"
  version "1.8.398"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.398"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d48c2e23c4960e3c09c604d93dab4030be08aca3f9a8b064fb83d0de78ff567"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4de1b3d5218df02d5e8813573de4cf10bdc1cf9def70b99ff8ecafaf20ff1491"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c382e2c334b4166e8965a99d5f088d7f9c041baf5a7bd84d7c782cb7c79f3795"
    sha256 cellar: :any_skip_relocation, sequoia:       "0d6403483340f0e209e0889d69e48f31559bc8b759ebe3df0cf25e530220bec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "331fc820dca8ad649a24bcc8f6acbdaaf56612d274c65d8d6f95880c69eea4d7"
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
