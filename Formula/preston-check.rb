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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.171/preston-check-1.8.171.tar.gz"
  sha256 "0ddd116bbefd65ad7017ffe313e31dfe8516b7432f5de817aa7b9ea4d2c23fae"
  license "Apache-2.0"
  version "1.8.171"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.171"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2385f6143664ce52a477f6475cd6a021889d247f62c5a18ca85503569ebbe48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5381d039d50253a94d508a8b8266d2e6eaa65750e5c3610b55c385b6c78e2086"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52a514c9fb50255e378d79ff308efa9876ca07c2170ade96f54ab8e436845ad3"
    sha256 cellar: :any_skip_relocation, sequoia:       "0de5d61c7278222e7dff784c4c8fdb68702a125fbaab358e20266bc00383bb7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c224858003149aa74a246ecc692f75bdde0070b6a1166c9b35c26f8f3347553"
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
