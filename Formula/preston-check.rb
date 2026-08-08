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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.275/preston-check-1.8.275.tar.gz"
  sha256 "8e778cf1171fcbdb13f3b8d2b86de25538c64ec887a789c119c84edf966db563"
  license "Apache-2.0"
  version "1.8.275"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.275"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d01e54f8dd17f2c06be7bbf3d5eb6f7d22b46268da4d67b9e5cd00325a62377b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9cf8eee2b2e755b0e46fd412d4a7cdfeb5dc5b18038f86c393913a82db5f9ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d47045867b7cbc2263604bccdbd7398833407b2b1a9820de2ace4eb55e828e3"
    sha256 cellar: :any_skip_relocation, sequoia:       "b80cc5a0bad40698de718bfe2ed910a95d518c4ae4c82118ff67e092cf0112b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48cefa342945c09c136bc200a7828dab1b5b725687a43a4c3bc3a96469aa0ff2"
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
