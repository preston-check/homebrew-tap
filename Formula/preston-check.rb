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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.434/preston-check-1.8.434.tar.gz"
  sha256 "e285ad41c16d81bece5348f30117cfdced58a6e83c76c3e64f6afe2564f094e6"
  license "Apache-2.0"
  version "1.8.434"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.434"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2131f643bc83f0d2e83627c8a7836ef73b28fc934fbf985b6848c8541f69e2e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92a993a7917008b9aa332dfd2bde08e931ee897ffd481c882284694f9104af0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62680584a08c09393a58c63db7cc395d32e1568ef3f6e4b80b4e5c9fa7c9e382"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af5fc29c40acf75ee4ca109ea7035081711ccb0560b021ebeb349db1150f5f26"
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
