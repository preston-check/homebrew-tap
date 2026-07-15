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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.14/preston-check-1.8.14.tar.gz"
  sha256 "ec4fffc95e2539131b44c2038df237d40f63f55e3dc159e7b206aba6b4ffc113"
  license "Apache-2.0"
  version "1.8.14"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.14"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28cc4af41bcc612db19621880d563bc1fcd9f1f3054df1a5a8e309c16178c618"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6db2fcbb088d863de37fbd69f1fd43cf83b100e2d08de07e7445693de7eb3a90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b60a466bebb52df35f4c626ea630ea8a9e32768c88a7a11b6c24cb889410f2f"
    sha256 cellar: :any_skip_relocation, sequoia:       "acc0f96f8cf1deefc7799f2d671a9de0cd12aa80e1bd46263368bd528a9e8419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a01bf7b3fd124a093fea9dc3ead4b41954454a3efa568bac3970691a2079c218"
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
