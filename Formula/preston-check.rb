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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.115/preston-check-1.8.115.tar.gz"
  sha256 "f686f6a730447dcd523b79565be23ee952caeb97e425765bcf4cc4526cf1c8b2"
  license "Apache-2.0"
  version "1.8.115"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.115"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c763df5c62d2d791482e9dfe8cd61e935df6ac16ec88e42471bc11c2629473e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74713c4de4096a6106c06fed340d1f3727ee839bf5f4d035322bf8c9531baf94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44959a2d5bbf15eff945f31559a32e843466817683df48435f036193a7bf7353"
    sha256 cellar: :any_skip_relocation, sequoia:       "4f5ff66ae0175fa14f161f874286a3b7c9a960c631cd5ceced5231c696b7df48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62d083c984fc553b264d14e7b4ac39f5c560b112ff025e991b688aada657185b"
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
