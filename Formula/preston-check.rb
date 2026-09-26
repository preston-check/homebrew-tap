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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.499/preston-check-1.8.499.tar.gz"
  sha256 "3b1bd5bf3913750ea9031c340eef7b20e1675526b726879991662bd7881b9d5c"
  license "Apache-2.0"
  version "1.8.499"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.499"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5ae80a4c9a312c3ca692601167318fb5de6a0cca95e78bc36fd4912f5a81b13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1ba2d8bc7e91c7f615d6521af18a334dd119ee6227eddc3817a05d15dcefd1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a63e98610c141ce86e275ff14634683c312900b22fdba3f8b2f16c47f4c5ee8"
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
