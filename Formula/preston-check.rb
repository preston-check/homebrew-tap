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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.151/preston-check-1.8.151.tar.gz"
  sha256 "77aeeb176562c21056dd308ff8149ff56354ccb1a8cb513afea00ce2a3802f0e"
  license "Apache-2.0"
  version "1.8.151"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.151"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72288757dade48fd30b712a539a805a94c3dedbc3a919b197da68a510485a6d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4ecdbc37381f7b9f3ffab1b05d1e1b9f7f7a14d907b92cb0eac4acf8cc07197"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0ee020d142020bce1f3831ffc31daa32bfe945bb1a39b9460ad79601aa846f5"
    sha256 cellar: :any_skip_relocation, sequoia:       "66f936fc36d9690d0f8f28b5a1b70d09e845a29b11df7dd2cbfff3eed2e7c5e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89f55d64e5bbb0adcabebf74d15524d06e0c3a9c788b85310ac06d717ed89232"
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
