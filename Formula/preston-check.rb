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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.56/preston-check-1.8.56.tar.gz"
  sha256 "f6c4b32087ea0cc978c32bc35c5c167a9de9f6796b11c0b507dc6dd37f12ec26"
  license "Apache-2.0"
  version "1.8.56"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.56"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1c20788affe9184e584d1af629d225ac765733e9502f288d3604679abecf84f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f61b169eb8bc3a4ba216edb9b8773758394ceb80e7bfe625521acc5cbc4cb090"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20480df74469977cc337aed1104cf1c5c327742b2fbd331743e8222803d6bc49"
    sha256 cellar: :any_skip_relocation, sequoia:       "7e8a3502a88189ee66851feab0cb1dae01c2b10c9163ae4417d931f5809cfa70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "583945c58f5613f05d3dab1da9e062d5a3e2dd6d3e740c412c117b8791c0be8e"
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
