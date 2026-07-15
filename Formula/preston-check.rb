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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.11/preston-check-1.8.11.tar.gz"
  sha256 "018aba230376b5135fd72f0f2d3a20ea8998e4786c9d6b1f180cce1f3642e446"
  license "Apache-2.0"
  version "1.8.11"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.11"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80ace9aa090b3790a37fef41a16cc0c20fb92707c08929abadc832266f5fec6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d407a9a739f9a6865b31f8506975864ac9f4d3b039eb63aa987dca11056e87ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50ebc4622df2555aa96c666c2cb26a083cdab44dc8dae22150518a6df6c2d4c7"
    sha256 cellar: :any_skip_relocation, sequoia:       "c430dbb38f87e85fe0cb96bb45b07e59271904d078551ba2a7b86180b67b38df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "936f0ac07f16e34d9e6e0de70c20a68d11500d5705c5e9683c3b5c7ba05e24f6"
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
