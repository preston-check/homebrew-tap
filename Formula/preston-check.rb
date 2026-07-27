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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.122/preston-check-1.8.122.tar.gz"
  sha256 "d15bec3e2417deb4e93d232c20afab4a281e8e87997254395f6c68dcfb556e8b"
  license "Apache-2.0"
  version "1.8.122"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.122"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc87e62cf57a82e38cdcc85c8adec8070e1fb01dae472a4575ad124628158c36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb4a00897a7b86d18a427406858768d4916d5b4e18a9f10c670f861c53a995bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b870d840bbe56f4d138c3c25155ba7943d44321d8aa0611f489b088afc3d76ea"
    sha256 cellar: :any_skip_relocation, sequoia:       "dcb05131b4b364b1a3014aa9709fd24609e72aa5bf9aca02c3bfdc07173ebd04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "186549e954432ca9e6c6e7a84aaab371248ffbc6b5e7b2e510bfdd8eedd998ce"
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
