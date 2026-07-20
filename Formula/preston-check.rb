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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.66/preston-check-1.8.66.tar.gz"
  sha256 "f8f942d72d2f0c853044f0161b5833234531b2a3cbad9f7944b8c5dab8c9026c"
  license "Apache-2.0"
  version "1.8.66"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.66"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38c69ecd61ed1a705b0e7ea236b95c934d5fea1cf330547c452214404e0825d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af7cc1b0a537010c862d11d13a3fca8e5f98afbeed3efed3a560b660a6b263d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a6f5e6c0a8bcd614d97f1a8d7f5a300651a5fc0f70977726a65dca0f3f9280c"
    sha256 cellar: :any_skip_relocation, sequoia:       "93d8008d7d1fd8752be69c7c95d01919224060527dc34cfb4b503d24cbaa2bf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae1dd5326f03cf9e563bc47e6389c4bcf3831831cb49d259e85655b2b8257bfc"
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
