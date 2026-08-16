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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.302/preston-check-1.8.302.tar.gz"
  sha256 "9029bcae24682ae9ea3b25f4ba8e6ea920ae5566e0afc7f995556cb3f9f95bbf"
  license "Apache-2.0"
  version "1.8.302"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.302"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e244320bd74426bf7e35a2b172eca7c4e95ad6fcbfb075d35a103dcb7fc23da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbc87fa8cb5bae8f21fb46f88f458bce4144cfda146ccffd62f8cfe07ff6a1dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bef6aa31e99446d9e76cf470d53bf4b3c61a7b9986bf4a6eecf65f53bd54157"
    sha256 cellar: :any_skip_relocation, sequoia:       "8703f3c52c77b4c58d89ad62c55fe2c70370ca06bdb944bb54b6a1c9b3178157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "432831f73b71ee0aa75fdfb2d7512b9860f0ce1b005d42bb45f30dc16526b04e"
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
