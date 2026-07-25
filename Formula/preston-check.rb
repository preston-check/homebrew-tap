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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.99/preston-check-1.8.99.tar.gz"
  sha256 "05e4e3ab95fc0df34b3932411b423cf12add470be0a6eccef8b3dec31aee9aea"
  license "Apache-2.0"
  version "1.8.99"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.99"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "607c2e5b4bb4ce9444782cf176580a64b622e01dc56c7768c84d7de1f4ae9655"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b595df7e0655fbb284c780ae6ba53440f5d0a6ce8ae91c05e1b68ae8f811ac82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "533310056563583991f5fa79f7ccac262e2493ff80d0917ec28204d8a7c66dd4"
    sha256 cellar: :any_skip_relocation, sequoia:       "31f423605d9e7c5be97ddd30c618f8732d934d1c24de6f3f4200a54a0f431510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e636440eeb721b945434ddc86058a53cb2f27943b7191da3ca8ebae558babd5"
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
