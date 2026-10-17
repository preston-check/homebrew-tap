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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.560/preston-check-1.8.560.tar.gz"
  sha256 "7192bf9cd3ccc86f50c5072581066b09db625f9d52bd849cebab928304fc245b"
  license "Apache-2.0"
  version "1.8.560"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.560"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f43ef37e8fd398c3d1f45f1052c491ca7c72b542b9e08626b6591572ab410de5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a25584dfc801caece9be44285c70f5c251b52bc43521b003758e95e1ca2bb1da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b353ac17f514cf1232fc12e0b2540d9323716c78e2bcebaa5eb238b08b98ca40"
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
