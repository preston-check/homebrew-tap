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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.514/preston-check-1.8.514.tar.gz"
  sha256 "df273ea1af1ed70638da699af3b69176f31968a6481d7571ea568623f5ec8cbf"
  license "Apache-2.0"
  version "1.8.514"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.514"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14ac657cbf94809307acb359ef14f5ffa88b1d35d208c6f44f44237508c9b8dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8aeadab5237a3e467809ab0a9c64fdce230f5380c86c7b3f36fd5bc675cd42bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17969a72449eb5b013549252b4d816870056191644d5591b30f42e7e8be0cf64"
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
