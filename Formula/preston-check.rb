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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.218/preston-check-1.8.218.tar.gz"
  sha256 "40fb442119b80652c8c3aa655ae1d4aeae9f2b5769e4c9bc01ddf28117b30910"
  license "Apache-2.0"
  version "1.8.218"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.218"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a462571ce8f6fe77360edfe751f14aa81278522b6ff24a17d0f300d4f720475e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44f1aed8c0a95e3323f14a8617bf9412364d26d4266f7e22eb2257052b8e6937"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4dfcfaa963bb10ec202adafe8e689f7c19092a66a4dbb7cfd6b9ddbf9c71103c"
    sha256 cellar: :any_skip_relocation, sequoia:       "9fce42528b919c97ef38e98ca552caffd41355ee16377765c902a0b3fb0a470b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d23a8d62589e692b20f6a329c3733f71fe8236066808eb263b4fb675aa4795e5"
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
