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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.528/preston-check-1.8.528.tar.gz"
  sha256 "c65d73d7c41862939e54177e349b2e1c328c467ec4441250f6ebe4a8446f8f19"
  license "Apache-2.0"
  version "1.8.528"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.528"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "356c0997c284d663af2be4901e0c96ffff4872fda752f2c8ae25cdbed1447876"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2654f8859b622a24a808e4d047ef001f80d2bf068a7e8f41d0c133bc147412c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0eb20eb98f7426db55f073b4c0362647c454885f9d183bca8f5d19a76613231"
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
