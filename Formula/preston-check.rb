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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.330/preston-check-1.8.330.tar.gz"
  sha256 "a8ecc3a15b62a4de94875ac777f7fb8025af2a95a19b9cd26870bdd8dcf59327"
  license "Apache-2.0"
  version "1.8.330"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.330"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8962e0226aa9b63c4f4aa2370072a06fb2f7f05d7ae94560020e1fc9d8d68070"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e63a5558fc6e833ba84604b055413f80608aecc0aeff7161e4d12fad79017e8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0edc76e7033035f5ec0e5c8b1ef94515f8275e8140bd74eb3ce565efae4fa497"
    sha256 cellar: :any_skip_relocation, sequoia:       "dc5ad4bd361407af02490723896cb9601014efa4e7e7efab18b583023f3c2be4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b93bbe5c125e6779f14800e634545be0a3e1786f0745a9c8eb9c4ced4dc8375d"
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
