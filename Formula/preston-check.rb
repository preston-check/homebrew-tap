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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.107/preston-check-1.8.107.tar.gz"
  sha256 "ae02fc5d99783c576eb6c168ffca736a14e6b8d9ceeca5c707a6b3bd09dbf498"
  license "Apache-2.0"
  version "1.8.107"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.107"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b263ccec75106f5ef38d795fdb5bc8ef7cc1dd6999d19c7a0d4d74bdf3f4c3d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ad3df508efca67097202e10bae80a24342f6ad8122035ef9b58cb528dc429bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b41c7739fd5fe0b5d2cc588162ba5d504e3611bc4c3276dc1fd09b056e030d1d"
    sha256 cellar: :any_skip_relocation, sequoia:       "35eadcc6297c091aa94450a79c73a3cf1070a23534baa7eecb5bf50f4329edfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bf0e97cc970363de6ed91ecb2dec92f0395918e0a70718b7da9624245f89fe5"
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
