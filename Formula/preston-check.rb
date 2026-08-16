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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.311/preston-check-1.8.311.tar.gz"
  sha256 "dfeae2fece87839783fde84003d6a764e1644b6450ae25a58f677ddee640fd1c"
  license "Apache-2.0"
  version "1.8.311"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.311"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "235676ca97b1a533ffda2daa3649ea6eab6c9f501e78615fe70bcf41fabd11f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f46241fa35dad8dd63e9a1bd8c1a78f7fc35b85ee7a7791681aec5baedac905c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c3dbe35b3fec25b5fd18e5b6879006f5c47ff9d2b1c17678aea5676af68c732"
    sha256 cellar: :any_skip_relocation, sequoia:       "da98cf9c2f27c8b0527cadc97d4c8e0c1ead99fc175470eced251fbcf57cb69c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76abf1c8686288be8173e7446c08afc6e536be1cb6e64158f46ce85a76d2a0d1"
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
