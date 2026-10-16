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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.552/preston-check-1.8.552.tar.gz"
  sha256 "7e44c007ab10753b6ec232d18811d459e51163429b9dd4814a8faeae8dbc3b8e"
  license "Apache-2.0"
  version "1.8.552"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.552"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eeffc4deafac5b11701040e1250465ac507d54d9bc5668f8470607352806bf5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d8ac1dcc21f4079313b4b9fbcebcfbf8d9150230eb997746525bbcee94bf5f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b8543ee6936423733ce8fc06c39ad62615c3ccaa041d2b0f983de37d369b508"
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
