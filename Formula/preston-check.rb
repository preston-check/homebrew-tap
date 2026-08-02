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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.193/preston-check-1.8.193.tar.gz"
  sha256 "6382edf13d3245a5327108d3a6c616a5affdfadb0d28b381b3e60e95b825fa11"
  license "Apache-2.0"
  version "1.8.193"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.193"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fb336b322e6e8d56beb69582a52db2693a715442b6c67cb750d64103717dfbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd7557c040dd72346a685ba3cd17a2a06437ba2d100656eb1de8203bb9e28c66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c22940af7fe47ce1bc45ba78951bc78f9f30a9c2b560fe9747bcf048fd3e1ed7"
    sha256 cellar: :any_skip_relocation, sequoia:       "aa456a6fe19a6a68f6384f1302e47c17a028f15e1de08abe04df63035609903f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52475e12071f9090ce8e488f0715f742d8d320818da974a51e3d55b5e7ae4f39"
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
