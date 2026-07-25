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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.105/preston-check-1.8.105.tar.gz"
  sha256 "95adc5acadea2f67f6f91f657a6e6c132332c5f02bd9b2da20c4514ece1e90b9"
  license "Apache-2.0"
  version "1.8.105"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.105"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "567cc38051b65e1f65d9dbb40f9d5e3e1ad77aba84ccd901529a98fd56fd28fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53105970c9663808d80ebfc95763dabfba7497e6b8ad0aa5f31cfa5330caf87f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6ca9bd58e125c6c421845ace69f3e947df5203992d411dca13067c83ca22fa5"
    sha256 cellar: :any_skip_relocation, sequoia:       "e3631d12c4792d2e06759a0b622c9cc7bda6cf86e2ce2db476142b62a9503023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce2c0981baad53464abf32735be4da198447f4d9cf395e51d7c82d8ae15ad32b"
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
