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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.202/preston-check-1.8.202.tar.gz"
  sha256 "65f570a66a66defecc320e495ebe2f889137bb453b5dd8af29769e827d3b7092"
  license "Apache-2.0"
  version "1.8.202"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.202"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbdcbf0f66dcfa5fe4f36ce79fac1d8f6a610ca0794ff5d8aa2eff46355424fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72b45bd2d31db60cd733a76a446676d73e74228bea614c70901b83de0c29a7aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09cd84ac11153555f2f4f24dbf2757dba0c1f2692ff778aab139aa01ce00e4da"
    sha256 cellar: :any_skip_relocation, sequoia:       "755373d2af63ca38e79a9a0e08b7388c2812783dc7df3f96a97510a9856872f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7df32dede3b441e4af99abf2ded73f361ea635d453f6775caf69d5d49f712b2"
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
