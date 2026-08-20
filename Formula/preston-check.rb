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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.357/preston-check-1.8.357.tar.gz"
  sha256 "03e856b9f34e28033ab5001428afc262a82d31d8fc056dec637c1573ff5804df"
  license "Apache-2.0"
  version "1.8.357"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.357"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d030dd7fd18cd0df512c0cdca20a95f4b7135298811052b9430dc32bd188fd3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b676550c778cf6e27303df6ce8c2f78bad5c75e72e3fb2dcbd1f7edc6f301343"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89337c87deb091623ac810e65894eb114aef71cdf6e18edf8a604f88e5fd8437"
    sha256 cellar: :any_skip_relocation, sequoia:       "91023457269bde6d424936ac05828103ff9b71fa0f0126d2805b99f6a798fb3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66d7eff4015b41c6ae3bab81653813c1076016b186f00402de1d2593634619d2"
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
