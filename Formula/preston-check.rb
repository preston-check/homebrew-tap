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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.384/preston-check-1.8.384.tar.gz"
  sha256 "169e9732dfff7d8b7821acd7815af1ed49d04fa717a17a67da7f6a8f7feb9dc1"
  license "Apache-2.0"
  version "1.8.384"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.384"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4fb4f020d56b85a4cadccd06d9887db9357c747f439ea5c97f714170a8d07ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1695033c3386b191f5253f1051ebba5156f4a18ccd2b022c66352f5d3a7f7bbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42d88a2d8009f1018ccd46e7ac6d3933ad0876358c8fcb500a3be3faccdca9ed"
    sha256 cellar: :any_skip_relocation, sequoia:       "ae25d03288e968e4fe7ef8f614092bf1097a3646b022c2be2040f7acb5025de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75206539257e056871cf977ec7d144386f833b4cfce18b96ab7119318f072db8"
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
