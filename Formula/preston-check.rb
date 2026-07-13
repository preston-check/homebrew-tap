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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.2/preston-check-1.8.2.tar.gz"
  sha256 "3cffea3a539d3b27e7d2e7f8ef1e50314f77457c7e9d9f1157c6558e4fb8e0b0"
  license "Apache-2.0"
  version "1.8.2"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d6305c7624b61b53db17a9e2f2ef5f3b7ba87b6f3a4ffad792acf46796564e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e08a0ceff2e585bf8c2fe549968421202957ee1eea4172a83849b0200e7730a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e45f412f32c304e859c2a864fb8ae8ee6c5bdc9ed825f90c61b32b56c5f302cf"
    sha256 cellar: :any_skip_relocation, sequoia:       "847394fa991073112c8ebe5c1e89fe10df88ebd969554b69494b233cbc3889a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33066137aa0baa69141ae7831696947eedc76ab988bc57980bcff3dd5dc415a1"
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
