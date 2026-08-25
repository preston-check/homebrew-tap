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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.388/preston-check-1.8.388.tar.gz"
  sha256 "45307c840cad2aae4a5ba9e841661506d081f6dd62f1bc5d8e940e64bae70e29"
  license "Apache-2.0"
  version "1.8.388"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.388"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fcb68a5d65822b3ad1eeb6cf84d115a1f8705052ff609f557ad65e6fdc7d384"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f92823d3f61d220dc15ef77f26e8b283d1d14e2a2cc83198f1044019f965040"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03b84955eba1061e9129e4d35e4460616415877b4c66e13408d1f914dba38b89"
    sha256 cellar: :any_skip_relocation, sequoia:       "41d4389192f41728054eaf9aa1904ea3e7c426915b9126be663e245cbe24fb5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cfc06c1da4bfa44e36e281a1ad77a994bf883388b311f13fe63bdf15ff83720"
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
