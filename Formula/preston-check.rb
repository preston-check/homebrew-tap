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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.46/preston-check-1.8.46.tar.gz"
  sha256 "bb8efc81f647bc72bf38087a439f3bfd2cbec28ed3b1caea7c5853cf30455a87"
  license "Apache-2.0"
  version "1.8.46"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.46"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb07cb8db395924e3e43b7ced1d04741064eb99a02b2a953a19c2ad888c017d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20ab0cbed8ff009e3fcd184dd463613f0b30e391822d4be183e000bd4bcb21b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08dcc96b9b793f27985fb4d6f5be526b7d5535da96c7a4b5b941626785f489cc"
    sha256 cellar: :any_skip_relocation, sequoia:       "601398816978f95355409b780e584ca2105d816aaf7206568d8ee56252775903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7640822bed1cc26ca605bba1c75d5963dbca3201afddc014037be0a3f5316c2"
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
