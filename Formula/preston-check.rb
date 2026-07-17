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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.45/preston-check-1.8.45.tar.gz"
  sha256 "0cae112116d11865ac7afad00094469e9e3fd42493c36e9496250bbbe9d9b9a3"
  license "Apache-2.0"
  version "1.8.45"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.45"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1b2d0963a355c2594ec3a45d11939b25fe193d26ecacfcc0edfbc7489b8ea73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bda29dd89504f995ac5060b92c09fa9eebbc5504fbe4f093449d5a6e8392407"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b4459e2d92a695e1add5bb995f82531f7f4d34c54dc61d756d0a74fbe336de2"
    sha256 cellar: :any_skip_relocation, sequoia:       "09eae4887174d300b54b591a2f7c99693fbe8e83d6e7b301af38b58974c14185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbb903106dbe56e27211d7824e5c9a0b08a55801dc78531df46d99a59eac6bac"
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
