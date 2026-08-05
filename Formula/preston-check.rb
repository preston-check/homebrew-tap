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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.222/preston-check-1.8.222.tar.gz"
  sha256 "300ea9c1d6cfd404303fab06d8b0caa824c63af9d73028b3f0aed280926384f6"
  license "Apache-2.0"
  version "1.8.222"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.222"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e664c1ca347074f85bc4041d2b44f1a66b18c21daf29eb4b0f8e4dbca26df067"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0859ef6d0f48d7d47087a91acba3a2b162b254cfc2d91950d49c8bfdc124d4fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b97451e59d4867e74a310f9bef92431d2844a4af7606f3991c6bad172e616452"
    sha256 cellar: :any_skip_relocation, sequoia:       "6cb5684d086be79d90268069a7a375bf61eeca69be2e2b788ec206a20d96c90d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32b1e0eae3abf7cec9b35ada2f467a08f2718c8a442a4ff62840601cc9a5ced0"
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
