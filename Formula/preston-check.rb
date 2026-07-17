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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.37/preston-check-1.8.37.tar.gz"
  sha256 "cbd5830885dee58041c06b3c07d0b3fe769d33ab4bf7b85ec5ad1077143d8e40"
  license "Apache-2.0"
  version "1.8.37"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.37"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a83bafe760e99678d6888556a8625af070b64a7b1cf92ce20995a56cc0e1e0de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "404081057ca4d8ad8d1b3d88345f8dfe564088a8f12e4617cddf16cc7101ac29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e247d12dfd082a9bbbf48e56654644b0345168e1e06b405bc2bb90fe76a9ac3d"
    sha256 cellar: :any_skip_relocation, sequoia:       "3377ac41286f04a14db96d5c8647d52ab997831926c1ef010ae6601cc4dd25ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdd9ac03c33e1e91c73494f1820506dd1d4aa54abc893b06686eb806b51d07e4"
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
