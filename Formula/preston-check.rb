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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.157/preston-check-1.8.157.tar.gz"
  sha256 "864eb0625d892bf424b6a10a8489c0db57d57babe0c279e1d287fdc160b85a9c"
  license "Apache-2.0"
  version "1.8.157"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.157"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c56d220b30a228b912a8b5e8831242db939f3f5fcbe7e48eb82b250ee7d9326"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e978ca87733d1bf8dba0da2cb69e15477bd3ea020d098f9f43f322f7fc5112e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16522f05d0ebfa261f8730ea930e5cec8fc288b425d2abe5d88cae3f9ad26cbe"
    sha256 cellar: :any_skip_relocation, sequoia:       "4c6c642aaf78bf61c39c18548085bd9e1783747f15be92a7bffa0c0abcdba6ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5b2cbd9df1b20ac8b820097c24d1d0c14632ab14d2bd78d960916f469bbbd1b"
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
