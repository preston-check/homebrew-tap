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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.411/preston-check-1.8.411.tar.gz"
  sha256 "d899971518bffddbef074baf633a63337126d13ade7a5c4dd1c7c9edd6af99f4"
  license "Apache-2.0"
  version "1.8.411"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.411"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f840bd07e6a385c04eb74f2915695955e73006a9ab4b96f7c5164d1a736aee27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2345f9f81b8b4b671c9d699ba5dc7668b77a2f4d75b98312b1f6ed270905d18f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aba690b3e7491af665f885c91a85010f1dc8eec839836bc31ba37f914045369f"
    sha256 cellar: :any_skip_relocation, sequoia:       "1cf5750f3789894a338f402aa803ed8d26bfe503b334fcf8a7a804029a7f75c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fbbf39c4c53a6f7f2d520ef05042674380361c41dd382099a55ba1c7a0c17fc"
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
