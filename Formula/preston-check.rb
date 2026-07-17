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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.35/preston-check-1.8.35.tar.gz"
  sha256 "5af76467ae0ee305fb2f4f2cec8cf963571c5434db3e73d773c54f649966f92e"
  license "Apache-2.0"
  version "1.8.35"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.35"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "660932c99028500ca236688ef04e6e49bfc00ef3edfdff43ea992962bfdd0a10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e3a3ddfdff63b44fb59687e8b848ea7420b6cecc9faaa92928ae918ff10c7a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf240fd97a499f966a4f5c47b3433b3eb2e0f689dde1a68b10d7066ae634a039"
    sha256 cellar: :any_skip_relocation, sequoia:       "1737bc6b3bdfb17a4450d8e4ca3a12e617dc89e03c26fb0fcc0d9c9cbdff40f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f89d7fcfe22d820c6f754b8adf4ef5ec7b92f8ab8b97e0daa8dc7f6bfb279f88"
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
