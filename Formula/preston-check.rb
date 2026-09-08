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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.427/preston-check-1.8.427.tar.gz"
  sha256 "2128e6865e5c0719bcb358f4b28420e7343662dd7f485186c4e6b908e547163d"
  license "Apache-2.0"
  version "1.8.427"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.427"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62f8dd7535560e72033e1b6adec10afd74b9a25f75dccc91b91f243679c2ae73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21a1756bd9604bd552f31b31f726e94712175b5782c45612fdb2f925d2a1e3d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "726afd7e7dd7ddb8a9959e02110e40f2fc07a4ebeb3fb653ab3bde90f6fd7893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "297e17b8f50e3ab15ac1a39881e2ca6709eb11e7c09856965eab83bf0ab3ca60"
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
