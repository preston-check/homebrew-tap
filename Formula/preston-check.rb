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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.242/preston-check-1.8.242.tar.gz"
  sha256 "8bf8aed9509543792f1b43eb2cde508f5ce2da7b018587bd3dd35535acb68e37"
  license "Apache-2.0"
  version "1.8.242"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.242"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b081226bb5b253d6deb55779db25275eed9a4ecc32cb353960789151aa07885"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0609ff87d09910f631823ff61dcb50bd11724f8a319a7931aacde340e5c4742"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c33bfcec4d19b1225c78a35f68ffb19185bfea587186e0926b0ab2ef06e59c38"
    sha256 cellar: :any_skip_relocation, sequoia:       "f058c5afc4bb181f2192a555dd8bce86188edeb0b2852a1871e738d99e3edfaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84621cc2b34abb3a1285d03a3fa0732e53fcc8580b95623d311c79c7ffa9906d"
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
