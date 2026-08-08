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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.262/preston-check-1.8.262.tar.gz"
  sha256 "d516218fb53b0176824af713e2732c209ee3c176c5d940709fda5922627da963"
  license "Apache-2.0"
  version "1.8.262"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.262"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b99d578f1c18e833e823e3f05465b297be9bea871eeb38731a46350e1c49bbf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b9d8af252360f2dc4829c01e5697ce78f8d24aec48c20b44a7d92358e04e948"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "065cbc41f4e531048855a984cd30b3574c9d7871c3accc81137e6ee535e73af2"
    sha256 cellar: :any_skip_relocation, sequoia:       "6ccdf490fdb402a808f42af44c17988f162e98bae3b9a8bf494c98251493c786"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "150792c524381281766f5cfbaf2197cb67c6a53b51fa160c24181f582691cbfc"
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
