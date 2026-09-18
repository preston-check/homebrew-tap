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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.481/preston-check-1.8.481.tar.gz"
  sha256 "2ddccea441b65fd9f66b66a82b5af44423244003265063dccdb65e1566f003ea"
  license "Apache-2.0"
  version "1.8.481"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.481"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c105f9089936fa11cabc49380004aca5ba183ba2b95f3b12fc20c2cf3ab10af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72d05058e519bea2e6bdc3ba993b50b071d7eb49155eff6a0681d5470987e618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c38f05ac7d1981502c0b4a4fba2479929c524285aec5aa697da2f1b48b220d2"
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
