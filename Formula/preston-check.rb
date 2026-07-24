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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.94/preston-check-1.8.94.tar.gz"
  sha256 "38fd8cdce9d4a3a38eb8f1a819eb3702bccbbb3184a43db5f46b42745b5c454f"
  license "Apache-2.0"
  version "1.8.94"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.94"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dfaebd527b0d0122f2acbc2e9eb5073f2c5c48379b9e6087f81d22f6ab76cf3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a891ca5e27cbed77a11381a0f08f0a8aeff82c674d1c9b11b8463e2cf96b9aec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "842c082f3cc5909f34b4e5b10d735c94d0296c0f924d2da5b374344cd26b095e"
    sha256 cellar: :any_skip_relocation, sequoia:       "6fa7775f1933a2555f70faccb10379903b95b2c11d8f961b914808cd336715f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eff2b6021b745830f560a64c4a7f7d354f94178be19a27189f4daaabe0bc6b1e"
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
