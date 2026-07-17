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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.38/preston-check-1.8.38.tar.gz"
  sha256 "8426af8d183d100b733a96e3d982443d474f30508ca175ad3a97f7b325da150a"
  license "Apache-2.0"
  version "1.8.38"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.38"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24eda0af4a011da7ceb7589338ae3385e50316063a26b290f01cbc0d04c631e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8478f674987371de4e1cddb8de9bfdcf69d6ae4c831728f64465d1c23bc453ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62584ef78afd8209fda21e95490ed105a6d20f80dab3618ac62382e0f8b54745"
    sha256 cellar: :any_skip_relocation, sequoia:       "ee44729417e857246c9d14e49be3e2b478d8937176296d6e5399d240cf0f7865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef535e892106440b4d554cf089397c41376a07f5a55c0c5a5baaff53900c735a"
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
