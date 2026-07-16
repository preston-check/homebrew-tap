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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.25/preston-check-1.8.25.tar.gz"
  sha256 "8ab3a365cec55f507c3680f0954e193e6bfcd7b6a36ade61a1e634d7ccdbe22e"
  license "Apache-2.0"
  version "1.8.25"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.25"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab5b7dcd6bf9d1df0baf55f0fd09e58ecfb1084d295428f9c8172a20c630f744"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26e13c73becddd9a1635ab3142d75acf0ec78f2cd9df60abd21b235044d9a63e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e97d1d4db5fcd5b4a6fceb43b7a1ffc2318a8fd39599aa05d4dcc942fee9c25"
    sha256 cellar: :any_skip_relocation, sequoia:       "7dbc635597db200ca6acde3c0fee40d9d045711645c2f7bbdc26ddc0e2c65972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74a4b5bdf10702dc7b47d5142397ff1d5f86f1f2ce413d4a45f18d6d19ae1640"
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
