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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.34/preston-check-1.8.34.tar.gz"
  sha256 "1321e1912041e49daa3a02405fa9f540dfd5d095c4d3c433b08739291a0ec151"
  license "Apache-2.0"
  version "1.8.34"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.34"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a1561d2cbb6abdc5899c804db815035109592608dcb02e6cafceffddd33f802"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36b2c6b656b732be2ff108f3e340074c9676f528db7e993ae968dc3b8f3460e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4cadd9e65d5ac231ee36ce5d118af774e13b51136cbc5bece85f9f1044f9d4a"
    sha256 cellar: :any_skip_relocation, sequoia:       "3fd4ecbf6d592b259f7cbe8e59c8544348dbabf891b9683abe6d6b01f65b0024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be6d2cd306a8c9952a970374cbfd031966b771975140217b6ccc5d5bfadfb9ab"
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
