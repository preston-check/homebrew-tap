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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.57/preston-check-1.8.57.tar.gz"
  sha256 "9a31b0b15cf544906a17439f77fb87588e878f025640296831c312d87b0d9fc0"
  license "Apache-2.0"
  version "1.8.57"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.57"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcd503f218db592eac3ec4816f73ae4331d1e3e47510b383c678f0634789da82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31fcf25d7a4b479ad049333ced7798fe71cf294d20e4576411da0bb6b04edbeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40644a5caef5aec5a26d0f04bcbb4c6609e0a3cdd038e7c9ccaa6fc2a0e4dd74"
    sha256 cellar: :any_skip_relocation, sequoia:       "9d50d2b522e32da9eb68197250572a60f0bcc506e9f570c6fc02024fd8b6fb72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a953c8705ab89e34dafce2566167bd4e0dea1a6d063fa4ab043389312211f5c"
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
