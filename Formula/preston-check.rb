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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.341/preston-check-1.8.341.tar.gz"
  sha256 "f34c9b999f6075e589ec99c256f94f7f7558b2a3eb472b2a5b485954b4a2264c"
  license "Apache-2.0"
  version "1.8.341"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.341"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2bb645314858868e57859d38b2084d14a52bd44ecce3e41feb7e04b6f214aac2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bedd6eb2298a439d49ab9edf97067e5797f1f0987f50f6412dce77216a4e9d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f719cd6c2e438b0354d505a3c0903d0a163f42c401e1e19c0757d4e53ce00f3"
    sha256 cellar: :any_skip_relocation, sequoia:       "0ce3aa0d28ed969d229bbcfd56017b1c083de800754f6545c0b9f01ccf1d251e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5944c17fcfbb1e6e4dfbd1dece159fdab33ebab281ec4e81329e610d19c00032"
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
