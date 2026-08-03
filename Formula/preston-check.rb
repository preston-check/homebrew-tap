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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.201/preston-check-1.8.201.tar.gz"
  sha256 "30302b2834317951427e12afefcc4e796799b2a9a8ea351ffc33d2365418fee4"
  license "Apache-2.0"
  version "1.8.201"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.201"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04e3d87aeef02d78b942548cfcb0f15fa757c4f6406f83c9c2cc7d6afa290fdc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3df9f1cf34aa6fb833a76207df1023d72ffbd4e06a33970764de04878735a053"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96a1582c201d398da6f4dd229e23956d8762c17c323e567fb88df5d85480295b"
    sha256 cellar: :any_skip_relocation, sequoia:       "2e2e33883d8bf0f51fa23c6966d66a0b885ec809f21188c57f5085691bb31445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82cdbba2749cf0a73cb8d0c3c0acfbb7553e42415dcea9d7ce5432e6eb67bc2d"
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
