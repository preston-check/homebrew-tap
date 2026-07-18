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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.58/preston-check-1.8.58.tar.gz"
  sha256 "b992b89e63ef27743f2d9214f82be5e3b779881c49db39b7049956b4fb07e77d"
  license "Apache-2.0"
  version "1.8.58"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.58"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b434cd69fee8eec277f67bd690b01374d9ab4e693c2747cc8115ce4746b2eb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c70670a34cbb177af888492a4b790ccbb6535ae644533da4b3f1786b327a880"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "430e49acf5ad0e27c2e0e668bfbc7de84a65f8b1213d7cf7e5427c47a3546d21"
    sha256 cellar: :any_skip_relocation, sequoia:       "ee9f864d1d24cc61193819451d3569d5c08accc116d79c4f9a64499843307cfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa6e032d6560f3b7d70518f99b9430fa1004ac00348ae0b219dcd007ebb0c613"
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
