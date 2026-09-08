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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.430/preston-check-1.8.430.tar.gz"
  sha256 "127a80ea6153f70ef73ea6e9ef0c5b8ab4003e0806d32bd7c3b63af22090460d"
  license "Apache-2.0"
  version "1.8.430"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.430"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4baa2d30ec4bf640bd8d1b31aa0f3d16f36d7f73c6cfe37d55010b3490cce4d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcf3b65110f02fbd487da4c8592b1fe98761b8eb438926889a4904c02837f89a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df66f6d04cd8156db0d67b1a66a57b51e5709c4303d47ef10850fc6613ec858a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "412021600c751724bfbcbbc60524dbece874823406ec03426a90930d1629199e"
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
