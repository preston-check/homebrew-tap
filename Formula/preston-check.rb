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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.165/preston-check-1.8.165.tar.gz"
  sha256 "1b944d22ba23d0b5504c2602e16854e19412463f74978c9ac8f43516e7f78fdf"
  license "Apache-2.0"
  version "1.8.165"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.165"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "696be031eebafb1fc3302eed846d580dba3a9bc775c16f190a670c30e0717360"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a72292c7e6441f80703a931d03d85e7722881bf53e1585a861c8a0f3d7f882cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72cde5017c05e51ad49b0b110ea4b83b4c2ccb10722e229c263f501f11571c47"
    sha256 cellar: :any_skip_relocation, sequoia:       "96d669f3d1c881c405281bf7cefb5a782b1f6d4d36ce3e02a9ec556f9eb3c45a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "221195d9819e462a70e8b491084aac7c98e78aeea3fc1a75261eb576c2bf3a2b"
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
