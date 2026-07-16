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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.20/preston-check-1.8.20.tar.gz"
  sha256 "d4a90773d42f723533c2524b6be66da4c0c6949f4b7f0397553436bcd47996f1"
  license "Apache-2.0"
  version "1.8.20"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.20"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "393f2787aadcc0c43ed5f6e0329b9d8e7e80f82b762278ae2558fadd45e02bdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9991bde09429c462662da9cb160b30f1fee0a3e54fad7df13ba2b9cf488db240"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d995184dbf23a2c9f0a20cedb925a9254e2e095f6cdd67bc1cbfe7aa8b12de4a"
    sha256 cellar: :any_skip_relocation, sequoia:       "a4b27962d4f36acbacbdd0267e5b4b0759acbdfa593fb7ccfdc594356429a0d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f71a7bf952d38d9ff7807ae11b14443f730f4ad6c98b8120cca48b6de072eb6c"
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
