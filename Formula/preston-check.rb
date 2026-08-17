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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.325/preston-check-1.8.325.tar.gz"
  sha256 "2c84c06b7cf4b0d9fb139d0ba4f9441ffa5cc25b2f3aed79b14c1b9261fc8c29"
  license "Apache-2.0"
  version "1.8.325"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.325"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10d05aacdc58e76cd1e0185336da087d6573ca5fe0c4b7b73384f108feb861a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9eb5bda971ce321295e649bbb6b6918483396edce998ad97c0cb061da3a61b2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fdde6ec6133b8ce9b6df35db5928c2978a2e1c429a59e1be86de5844cf17021"
    sha256 cellar: :any_skip_relocation, sequoia:       "728e26396c5092a43c416de54bd68136ff0c84513546042ff5c6e77a1eac8993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de009b5c09c2c6a23333d431eb7030527b1492daf5ac242c528fdd2dc1404ac8"
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
