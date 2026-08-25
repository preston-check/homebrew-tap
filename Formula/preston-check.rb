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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.393/preston-check-1.8.393.tar.gz"
  sha256 "31f5788a8abf93d043b50c2f2db362099c5fa37eb6d1e9087aa30c7bbd51075f"
  license "Apache-2.0"
  version "1.8.393"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.393"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23f032b1c3d7d7a4b0a0847e71f4995b72e797c9a9c114df964011f72bfd4355"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0d74da31717ba63fa602841cc39a9a7e0a085c4d9414611565d60fc2b66f74b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f60d02f38ea18dbcd91fc5c057b81a7d8b575498996fd8fa29a019c43b29f5ad"
    sha256 cellar: :any_skip_relocation, sequoia:       "9ef6bbcdb6274b30db29ef5b3e5452a2fd0215b4c1d94ca55fa40eeafc7d1dfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f59a52adc91f77877e86230433998939916237b36a6e476e7f96bef088b9fa8f"
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
