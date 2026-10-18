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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.562/preston-check-1.8.562.tar.gz"
  sha256 "064fbd40b30bdd214f0fffb136c544e6e6c51fa77c16b3ebcc95dbf143686e0b"
  license "Apache-2.0"
  version "1.8.562"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.562"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37127bd7748ccf636946860a8ad305f9d9d3b894fcbed32271dfc75fa07d1d22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fe5a498c30b3ce7a9b934222881ef9a6bd932e9cdb8c2f318afb8a035531ced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b76e5449749ea23488d4d3c6aae22d0eba1d2b67afdc2e8af7a701832d28415"
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
