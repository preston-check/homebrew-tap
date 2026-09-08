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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.429/preston-check-1.8.429.tar.gz"
  sha256 "de5aa7b07175cbef2b5df16e329740a8ceedc6e9b93c89f49d8a4a96244f4740"
  license "Apache-2.0"
  version "1.8.429"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.429"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98205c0e433ee0088f6a8587957df54d03b4eab5c161ead280eb7d1071af37a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab6c82158681a67a069ba0a2c53a89ec92051de6210b9aa82edcf05b1afc9aa1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14a90b1904a48337f79c8959b4ba7a97b5a4c2de9fb45646d3ec36912c82215e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "409e5734b3e470f60d031a2d04c06c4975d7f936a68d98aed4edc162e0f4bcfd"
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
