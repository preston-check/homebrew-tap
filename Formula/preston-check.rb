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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.4/preston-check-1.8.4.tar.gz"
  sha256 "5c66f5ee4c9111ae7a35458d95f509d7be99b57dcd09a669d4f5b3e69606ee3d"
  license "Apache-2.0"
  version "1.8.4"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e9441fb35e67d7081c8bc628bd667f92edb462f36fa52d563b99ce162099d52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bc9d0343d9590c525ec05bfe20ddf94357d28fc8a7879d030a056c20aff5d3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af0300366b9f050e900fd1299367602e4e1ecb6f598923f8ff89a350a1c4e09b"
    sha256 cellar: :any_skip_relocation, sequoia:       "adfef8cbdd2a62dab50b13e9b6d04a0a65dbbb022b9175ef38563dfbb5dcd570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec4527634c33cef59d37a5c8ad33b1a1830c7efd14e438e98bd782395f8ac816"
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
