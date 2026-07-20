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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.65/preston-check-1.8.65.tar.gz"
  sha256 "5ba4458b62274d85a55731913beb17045517ed9109db5381aed818a2f41e7a7c"
  license "Apache-2.0"
  version "1.8.65"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.65"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42e42ebea3d79e63372080256ee3101952b8e84b1c3d14011c52f1b0861dbe58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fcd5c6c38b9c8930aca74dceb36cfd49a589b4cae0a664e0b9aae069d511d44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcd512833997c230d0ea5b98c89e8ef7aeae853ff9456294e59cd84e21db1113"
    sha256 cellar: :any_skip_relocation, sequoia:       "bea10cc8bab3ba44769224f00f462c0aff6183ca8b3e8a4e25e6a4df51f61ad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81c6b86604f5624be33929733e8d8893ebd74c061b59285a1fb3cfed8ce83279"
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
