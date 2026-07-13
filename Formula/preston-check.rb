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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.7/preston-check-1.8.7.tar.gz"
  sha256 "329c7f25533c7aea39432575b2211a662c046a75aca24cce4a08316dc75bbd93"
  license "Apache-2.0"
  version "1.8.7"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e889940e8faa532098d7ab21fae6370361d508c434d3a77c3399c8f053e2113"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1136e9a5aeff2f6c1cf20ed9def0f402fadc266499a49b2fe04509adb1d826b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4b182a46043f1ae92b85c023fad65cac0f485c341ab4af5983519e1d9598177"
    sha256 cellar: :any_skip_relocation, sequoia:       "ea35c0faa7e26e02e9a522882ef60e493de8ad698a6cd1fcdb095c9ae31e3a6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "790d4493d6f38e959cf151f57416b52537c4e12a4a113a015ba2cfed464b3f2f"
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
