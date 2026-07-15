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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.19/preston-check-1.8.19.tar.gz"
  sha256 "225ec849f65d7a06cd707130f4238e92e4e2d114ed1dcf46287d2a7809d02369"
  license "Apache-2.0"
  version "1.8.19"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.19"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a99fa58104775002872e89a3ccf35c00a12fa09c5966cce3f7103def64ef2a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faf901f50a3b0249b994e9c1aa3d1cc94e380f9de55501e4beda8233e7c2d90a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af52fc8c121e668155d41bff99801df4acf0257355e4aa9ba0f4054cb7986652"
    sha256 cellar: :any_skip_relocation, sequoia:       "9948849e74d03cc1636a6978dc23a2ce5681cae172a6136fedcd7f930db7d9b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f2c446e69d076637dbc78e6452b061c09adffd6057ddfcd671154abcf88c475"
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
