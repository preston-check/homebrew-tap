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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.326/preston-check-1.8.326.tar.gz"
  sha256 "8ad8e0972a89832964728d3ba98f29b80552e699170217c12435b9289e5abc84"
  license "Apache-2.0"
  version "1.8.326"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.326"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d65bd958895da1dd7b56d1288782e3024656190b79f670c1ead3575982942b6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc275744dcf91211ccfb1f29e783841920a0b949f67e5ddef3d70762e581fe54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c42a957d308585bf10574faf92a33be0f577bf300adfacfc77d6799c29aefb29"
    sha256 cellar: :any_skip_relocation, sequoia:       "7ab56806107a6e8596ddab3ddb027f975d6cb4908d39a797e6b26e57236a119d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d78ef964c22fcd626e5396de34ce04568c7a75f98125cb436ed3c7f24c776737"
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
