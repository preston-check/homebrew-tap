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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.501/preston-check-1.8.501.tar.gz"
  sha256 "f3c5c25de87886e4e1e33d0efbc59c758b4dd90ae56d014f6766ba42f8790021"
  license "Apache-2.0"
  version "1.8.501"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.501"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8d3122949bd043c824a37194b8481ad69340ddfe41f9d10a7b70b192d2ccccc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5cd93235e16ce80e34466391332000bd938c4de549106bbfead32920d6013c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a5bf38e26d601c475f6a1c86083f5e45ee9c6d1fa09a5c159bc63d8ce40c50e"
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
