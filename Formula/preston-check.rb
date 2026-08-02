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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.188/preston-check-1.8.188.tar.gz"
  sha256 "2c48efad57d5a4cfa7250250d73b24f0337b1c597673080b91cab6d73013803d"
  license "Apache-2.0"
  version "1.8.188"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.188"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aab08dd13a718b8784e1d2b722441bb19bcf4b7c47cc49d59633be4f21e92072"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72f8531aadf433f5d6d238622152619e805da31fe96f310ec7c02daf7f3f703d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bd62e717852335fe447459f4a643ad273f0323b14276e3ed28f6600fa31201e"
    sha256 cellar: :any_skip_relocation, sequoia:       "f2b82532bf5df5ac4ad732eba7c03924d847b6f3f0791530bf7d53218d9e6cad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ec7b5f9c8974c61164a9862ee80834e4a086696f48c7d96fbd1177af1ee137e"
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
