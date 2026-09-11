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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.446/preston-check-1.8.446.tar.gz"
  sha256 "af2ad07d163e2c226de9d1ce669ce2e96d4937f8902cfa29bb2d3e2cafa0aac6"
  license "Apache-2.0"
  version "1.8.446"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.446"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "511ff5f07adff0a06333f140748f550327b6d089cb670d07271ab8a47ef65128"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2afd819532b9b4e56fc359e5c31cc265fd5e503b43786572b7e6d4e1030b2909"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88b8741034c9ce46a2c7f0366879e986efb0bbce5786296075a7cbc545dbc80a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d942779e005d00f9c93809c2ce535a2f234e6be6edaea513f86568aa6c958a21"
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
