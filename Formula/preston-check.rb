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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.374/preston-check-1.8.374.tar.gz"
  sha256 "6b21608fe108cf59f9192073a7b8afb5d609b1d14aed88f915ca23949a4479be"
  license "Apache-2.0"
  version "1.8.374"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.374"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42e2309e070a90542fbad89348acf9b6f2645eb828fdaa61719b6519866c18b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "633896710d6b56782e935dd169172796056e06739bd350008382767dcc5dd02a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f1baa595830e6893e11ccda5fe00bb78b1c57abaccbf58a0904c8d4b0319b65"
    sha256 cellar: :any_skip_relocation, sequoia:       "ad6e8b206f87b57291fd048c5703fc1323adff036124a093ea125c8849c474fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3a7ea01299a3db2e7cc10e4bb94366f971011caba87430b975812188a73a128"
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
