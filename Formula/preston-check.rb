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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.147/preston-check-1.8.147.tar.gz"
  sha256 "930712c46184ea63f3b26c3e57c32fa4032cafc915c4bd224c5f01d644f60baf"
  license "Apache-2.0"
  version "1.8.147"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.147"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ebbf3477d6f18d862047c391e1eb90cb2c7c9b2e913067dae2c70f0a776a52f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "629d78f2e7dcff162c762ec7194ecdd985aa44bc016e000eca94b1f0ad4fafab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a85eb42824b3991b0b104cf550accf2a299df5f7a4a5ab39df3d495d2560eebb"
    sha256 cellar: :any_skip_relocation, sequoia:       "710fd03998fdb98e1c6ef5adf4057f1107d476370283046edbbc5237da19b251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d07bb01e3f2d78584cd8ac8a409a0c065816e9af12e596b03174559a2cb5f221"
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
