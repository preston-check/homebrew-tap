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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.444/preston-check-1.8.444.tar.gz"
  sha256 "349c84343fbb6d38c1bca546a27d68e71bf96db35146c1c73ffe110bf79fbdd4"
  license "Apache-2.0"
  version "1.8.444"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.444"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e281ea2d7650dc76eb5ee655a9d73249f7746f0e94234c3b474e5b96be41f7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "029430a8e84fd99e3d5e72314ed3deeed532363c13f24e81e7a792a6c1c9a7f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "277e0e7dd521e0e4227dd398fdd185d449d0e038836f77344bf98b9538f31364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b20b971e259c62a4c33ec01510affb797eca5a0ecebad5767314d56d7988e0eb"
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
