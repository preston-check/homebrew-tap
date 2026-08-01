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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.183/preston-check-1.8.183.tar.gz"
  sha256 "21b1daad23966aba14d92ff0ecd2eeab03cb410ca0eede8fb8f6eee8d0c60926"
  license "Apache-2.0"
  version "1.8.183"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.183"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "466abba5816cdda1d8eca5cf001119f937c5f5f9750748054ccc645125e73b5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7406b056c23d685f23ea33e0230c4ea8aea63d957268822d25c83f536b7a25eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e18033a9b030389ca3732351cfcc4fe771810821a441f05e87e9629054e0981b"
    sha256 cellar: :any_skip_relocation, sequoia:       "e76cc1fcf31fbbf08c330a954759b617da5f44dc70e1c9a4a1000dd647f5d8ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbef910aff19064eea3b9e9a8044f31ff1e77317e67b4934cc698efbd4d17cb1"
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
