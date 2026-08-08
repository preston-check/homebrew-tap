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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.272/preston-check-1.8.272.tar.gz"
  sha256 "7493c2429abae3c6fcf1eaf7e93181bc11656b4ddf27b69be4717e5c2db1e92c"
  license "Apache-2.0"
  version "1.8.272"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.272"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f36ff36c1495407e9d2050dac9c549213ef3e8040b028f307b10f78b126fa75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b902d267d6ee92e64b13fdc58d464dce8ce842b333dec87009bbda029a3f30c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92faa3961cf54ae33c531dfa509bab88180aca4428c83de1f858a327f1827017"
    sha256 cellar: :any_skip_relocation, sequoia:       "1dad7e314055ab1a1c5e8731167815647229cc27a8787f99c43ed8328efc7d5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b84a30a9734243640fcf54e9df156a5f978d2cd4562e0c4417f1893eb0d36a9"
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
