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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.288/preston-check-1.8.288.tar.gz"
  sha256 "93c80fd1e386f2c80ec4ddbe98c38fe0ba42a2e8382e0f5a2c7d23282f5b535b"
  license "Apache-2.0"
  version "1.8.288"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.288"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "921d292707f4989ceddf505f15cec1578d6266a615b2ecf98bbee05958ad4f7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d81f1ee95ccce7179edb76dd6b1b09956e7e09be2e8bdba6d6ddd944d0ca51b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1813324ce8fe46e4e5e0e04fc3f699ee63755c69384500b6bfcba52687d187bb"
    sha256 cellar: :any_skip_relocation, sequoia:       "1bf22fd171c94e721d4965c68c6dc444ea58c3c65fd2e61bb3e874985b7faa63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9fd47b130e898ba2c9987bef88663143ab87f06dadf42d6062731e757d9faa0"
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
