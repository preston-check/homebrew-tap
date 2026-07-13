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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.6/preston-check-1.8.6.tar.gz"
  sha256 "02af2553a563e3e556ec8ca9b89a4cf04ca53276325be152fd18011f625d3574"
  license "Apache-2.0"
  version "1.8.6"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea0b44f729da76e75fe25ab2f29493158a16463037e3e63057ddacb6b27fcdfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55d2e1ee181d6e16c46ac4e3f64c0f3cbcd0d6711b7bec5260e716463edbdcc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9abbce213e2561186b50320442bcae2660362e01620975a29ac3a1d316a10204"
    sha256 cellar: :any_skip_relocation, sequoia:       "e5db84b3e16db96bcbec25c2e9acd1d8277d69fb239ceccb9e2aced28e2fd3e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07181f16fca589cc23a4a628620b83b73e1f733204e37b1ec4ad5856693c6b64"
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
