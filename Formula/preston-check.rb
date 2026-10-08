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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.535/preston-check-1.8.535.tar.gz"
  sha256 "355bf28cc6dc8a0acb3ed03ec0a239647893b0e70ee2991d523bf5b1adffefa2"
  license "Apache-2.0"
  version "1.8.535"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.535"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2aba60a5b22d77ea0cf4972613bc1f33ef796e3340d1b242ad690b2144243869"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93d8ca5e29b17aeda920ad7a6eedd1d4e8b51626cb0f0f04d62d73e27fca7877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "177a63e53b07f77cdf8d75f10cfc12235b24e2c73f893b6c9a1c7993cff54279"
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
