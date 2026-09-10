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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.442/preston-check-1.8.442.tar.gz"
  sha256 "f80b4ae906b93e67968b4ea988b542b4c3f619e7722e277e0fa85b0d1b456841"
  license "Apache-2.0"
  version "1.8.442"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.442"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98a101691087678d414da1b3f0b7290a278f464764b1627fe3dbcf97800255c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddaf497eeb0f72cde5c9ba78db9b99b254ccc73669f552a55e7300d1df3c72d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01f208b76831a6b8231db645c8383b8ef57ba592b655afcc0a49cec2ed15e722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a5e1a2d3438dfc0685491d9424a299e9622c9bb02f64ecaff657d28fd6b351f"
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
