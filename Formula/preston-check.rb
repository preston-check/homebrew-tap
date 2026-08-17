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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.322/preston-check-1.8.322.tar.gz"
  sha256 "141b263273f8a30861c71498981516c84eaf6be80923a81b31119c1caa369cee"
  license "Apache-2.0"
  version "1.8.322"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.322"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd77974a5378904f3a9b69c2bc0a0560b6a56bfa6d0a7d65503e230e8dc481fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d99ee67fb7b8c09eb9ae0c0f4e974891c3d78931ef271e59d0eecb04eb236d0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4192e059868ace04205883c76a5c9bd1261c9e9768d2cbe4e8839fc8b028a7ff"
    sha256 cellar: :any_skip_relocation, sequoia:       "7989571104c6d0a04cbbe3435f8d09cf0ad4c159ff8428768a0ecc23fe322e58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7859a3b1e99cbb940132cc8d52340726d0598acc6fcd28893cdaf2ac624eba1"
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
