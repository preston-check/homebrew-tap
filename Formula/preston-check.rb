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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.114/preston-check-1.8.114.tar.gz"
  sha256 "07f9a818588c20fb1d88753a283218e6c04407b147df0a685dbe05c5940b95e7"
  license "Apache-2.0"
  version "1.8.114"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.114"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d735f04c4f529bbf359dd3d40d2bd4c7cc6420a31791ccceb64d5f6b49cdf25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "100c46d11e4778ce6d0ab06678ed5881016f3f6903b749c2d3f68695c8cc8ce9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ef201a4abd5c7f1dc78e510569fcf7e8f73ceba5e30ccea0f91e8179826384b"
    sha256 cellar: :any_skip_relocation, sequoia:       "5345c16774f7f24b17b30582968fc99f3d11095607f3d4f279ea8e8cfc59a872"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b54e5c16cae222b4a74bad9c1a7e25601252400c9aeeafef9cb21eb4b3934a7"
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
