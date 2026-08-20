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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.354/preston-check-1.8.354.tar.gz"
  sha256 "2070af7f558a90414d9cfa52ee9b01ac12cd3f8a0a91e3ccf550d14c01430f4f"
  license "Apache-2.0"
  version "1.8.354"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.354"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a89fc7058e108377c676cf367440b93608dbe43106584f516774e4b371fec942"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f82db7547bd097ff3d25e691edd975ccb8ef314d49fcaa24c5f792a5e03d7641"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "637b00a223188137334377065104533bd12bbddb829b487844d0f4c769248ba1"
    sha256 cellar: :any_skip_relocation, sequoia:       "f6143bc03bc451394b3c4ffe96db63bc2de3ce647ea67ebe5f35a624faf9457c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a62258633f5d47652e5b0e5b1df29b9c4829a71ea60000cf7ab6816e4b2cb6e3"
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
