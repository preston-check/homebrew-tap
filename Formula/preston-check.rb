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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.156/preston-check-1.8.156.tar.gz"
  sha256 "3dc5957492a7aff3ee4db0a4ab930970c095125bd4c1d23f5cb6b05db1c9e223"
  license "Apache-2.0"
  version "1.8.156"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.156"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0494fdf637435316f7333f40ac23ff0a0eac7f774584afcf495b16fb229cee33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da55fe3c15440d3b0ec84c111a05036895c67cf7ae7f2b221c442018af323123"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c5be4bfc669425fb11bdd41def36bf228238c51b0db5332c9d16695beacb40b"
    sha256 cellar: :any_skip_relocation, sequoia:       "52d0ab72e1abfd70e9cb764014a8cde9628fc148d78db77d89be541cf9735e7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c9554177de5daf9c0ffac3ed308d9e73b23cb0a602ddb215ae922aa93960cfa"
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
