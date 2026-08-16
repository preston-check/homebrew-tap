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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.303/preston-check-1.8.303.tar.gz"
  sha256 "4895f05a3f2a498568932f87c3f24c8f6f54e0f453ab874038d8c45acb848741"
  license "Apache-2.0"
  version "1.8.303"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.303"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36bab6dd3a33e1e494dcf6152ef5f2a5894dea15a750f4fd9b3b70d9dcae4686"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87d3e81733421cd89bf9c603a52c80eee52d2556061f0c573824158d8ba0b19d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91526ddfdc5a054de30827141f54a865e80c6084c44a18477bff1dbff93505a0"
    sha256 cellar: :any_skip_relocation, sequoia:       "1e503d4e4e7c1f22d3a8d9f9e16a930ddfd2aa5001cf399b9cf75f8c4a9e0bbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e991f4b9a8aa26103ef90435ec0f81edcc82e8654d70831b95790b2cdf0b7875"
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
