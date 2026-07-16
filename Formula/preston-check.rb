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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.31/preston-check-1.8.31.tar.gz"
  sha256 "2240556c65a8ab338ebf4c46798eab28a4731a5b2c8a76f4266b005457c235f0"
  license "Apache-2.0"
  version "1.8.31"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.31"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eee9f083a5158a0a7f7388b1b6e2549071d18fb88e1b902fa10c91b631fcd978"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d83cfc4affdd73eff17c9774f372fca392b870a2a90338167dfdc61b3e08d20d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb03d48b8920eaf745e515b264d14317611ee9c3131f62a5ba90e0789bc17d1b"
    sha256 cellar: :any_skip_relocation, sequoia:       "cdeb6ce204b73dd8b3d5355c519869b916df84e3ebaecc339e7b798ca73f511c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25ff2eaa5dbb6a05099360334633d47e5cfd4af7030d784e847a365d4e895fc1"
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
