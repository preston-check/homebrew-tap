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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.246/preston-check-1.8.246.tar.gz"
  sha256 "3f9c1f9bc5e62d4fe30b6a5addbf0b3190b7105efbfd1ad1bdb2484128da544c"
  license "Apache-2.0"
  version "1.8.246"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.246"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79caaf7eb8f3f3ac4069a28f104dd5093f882bc2834391077c9a01fad1f6143c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29d1774be94e434c11f9d77d3fef95bbc012248bb651641becd527a3d398fc09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a934c35b602d0399edf9e011d053314a2edb8be7bbd69341f25f04c0a59cd850"
    sha256 cellar: :any_skip_relocation, sequoia:       "ea781f6ef7f9d335ee1afd1b6d249b21b3331e7eaf1a589de4f259d99d35cf0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cde22ddb786c34503ab005d6f5946f305da4524c7fc6f44ab7b00137fa8e3ad"
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
