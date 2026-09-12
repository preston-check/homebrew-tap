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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.452/preston-check-1.8.452.tar.gz"
  sha256 "df83a785a968d2bb22f7359597d1ed365e735b875d085577ec7ad5d859b322b7"
  license "Apache-2.0"
  version "1.8.452"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.452"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "151c616fee309a6cc47529c79b760e4f3efb594a6c1a425c5998aeeb3f470f7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b05f52c9037d7afc0e9312af4bfb8b13e9cc1b93ba571084469754dee1e7587f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e70852fcbd0441194007b12a3912f59fecd7f22c80178ca73322223f7a6368bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75defa4ee8ebaff63fa6f38c1535833f3177fb615680424338110d5a35468fe3"
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
