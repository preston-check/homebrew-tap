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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.36/preston-check-1.8.36.tar.gz"
  sha256 "dda24214e556985da7b839b235df28bb6d030c3627aaba109792993ab05fa4f3"
  license "Apache-2.0"
  version "1.8.36"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.36"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d01a945c9f8e4c0b72273a30dd29c73af08822008519c4a218854ded936b489c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b5ea874258476acb50dfca64c251ca922de31ebd180553ebab31ebd5721a38f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f735630c3717039ee7170380533d9d827881249007b245c0a35c0b846d65c202"
    sha256 cellar: :any_skip_relocation, sequoia:       "0c9a9e5453bc0bbf17456c83f83fd2d1152acc9f056339dd8c0c026797faf994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ca4f4028d422c744369772b3cc70f53f2d592069cb797b56cdef843b8001119"
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
