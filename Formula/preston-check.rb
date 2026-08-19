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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.343/preston-check-1.8.343.tar.gz"
  sha256 "af7ad81394fade21ca7a840c2b384ef45da6b382e2b50d745115e60bf7cf8228"
  license "Apache-2.0"
  version "1.8.343"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.343"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61fa10c47d8af6034bdc2debcdb40a8fda884a149c4009086b2d9e5e582411d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b80ae5a1e38dae82733e60e691228b9e49dcc4f37879e85712b7a3e9f7db3c25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4eb27dacd95958f1c6c24e1ed6ae828dc127a5225280b61d05365cdae6a732a"
    sha256 cellar: :any_skip_relocation, sequoia:       "cd03d6e4d176dcad077ca9b16da42fe94c109859770104236a1d1ed7c172eb92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "654814fc810c9ec171b3d2c135aca35a4b47e545a65f6ccf8f175e7b77ad5f9f"
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
