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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.521/preston-check-1.8.521.tar.gz"
  sha256 "3cc15ff53cddbf6fa5e37bd6af44caa4e1b7dcc010fd85ed5248a2ed716d8ee6"
  license "Apache-2.0"
  version "1.8.521"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.521"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3573f8f9607eadf1b37bf1f06c4370a944916cceeee1317ebd67fb1c2d282d21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ebd2a6eb7110f240225c0d6dacd5adde0f0ad89c53df9faed94ea4de3d5e654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f58d05bf7437fb36bc48eb8297b0c1eb1bf05f225f4b055a43aecd17507a862"
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
