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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.24/preston-check-1.8.24.tar.gz"
  sha256 "ef8156a9240c7689ecc2d1d2416bd2296cb34b25d2454908205c511696a5ec5d"
  license "Apache-2.0"
  version "1.8.24"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.24"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4812fda598f4c51c7f20829ed5602be24eb39cb3df30767f7ae0d63fe4c49d5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fbcdc3f9466249c09810bf600d8236898ca23f441ef707788a3815ba8ec8d2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a6d431d193bd5d922417dd344f5cf567317a2e909139fd52e6d25fecfe151ed"
    sha256 cellar: :any_skip_relocation, sequoia:       "c1686717610212d51808a8086e7262c1e53c63af21cc912d4557ff967f781f94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f56563a3cc88ae06130504a8699b70c782a6f8e14bb98127c7809a02c823b3c"
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
