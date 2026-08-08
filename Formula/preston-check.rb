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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.265/preston-check-1.8.265.tar.gz"
  sha256 "dae8df65566de2230c86c068815e5a31b15351794d67e8564a96ace7b95642a3"
  license "Apache-2.0"
  version "1.8.265"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.265"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cb0a2d7cf5639e504fd2bfc724d69da3b8681e73b4a736c163f104762b5fddc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "104443fed8dd7c5a6ffa89cc77696284fcaf062b108c1cc0593492e1cd4cc655"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9d2ceecbe8609b57554bd457f937c88f2431e49b3e9ee5ffd24a7f23f09eeb0"
    sha256 cellar: :any_skip_relocation, sequoia:       "40f091b0c6646996de0887160a558051e4218885c0395006b5ad6c4e747c03e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23659c4f1abee0c3012450af6903984faf393eea0b4e21d3bcaf81005705cb95"
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
