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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.207/preston-check-1.8.207.tar.gz"
  sha256 "84fbec836914106d00010dcc8bfe188726c8519f3a2939e2dd29e0913d9eeafb"
  license "Apache-2.0"
  version "1.8.207"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.207"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4907931ecaa9745ff03ae5f88d786d970268fa0c269bc1daf44127595c07bf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d8318adac865fd4217434837a57423c8cb827e24f2950acbb5f1e3748366337"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c687a70c872dfcc26672b8aeec377e8ca14bf2cc5163c01c64b419f196ecf31d"
    sha256 cellar: :any_skip_relocation, sequoia:       "6bf04811e04fc558f831c76608f3a28a9c5b67f3c45b57c16889774f26fbeb09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83472bb7c1128761133e48a82b4f9356e99367a2cfc39b3a018b6b74e96507d4"
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
