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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.41/preston-check-1.8.41.tar.gz"
  sha256 "451b1f6d7460b332998dd6890b40548cadbf35b3edd5edc663a176153eb1aa97"
  license "Apache-2.0"
  version "1.8.41"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.41"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebfbb5b746a0a83316332fa8616e130e616de94e90ef84c83b771a01771cc016"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cc7f730ec8f58787c331fcdc4d999f236d422003c31fbbab4087e8de2b22130"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6ae00eeb9b865f9170d87d2aeea0c4149b903ec22c64558addf5336a1438ae5"
    sha256 cellar: :any_skip_relocation, sequoia:       "0a87fa190b86e2719c964d41ee9dfe681eaca3d6849ee73fb93d1eb6deed6082"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5856201f1d81d8dcb06d289b413a9704a02e3a396d9e217a41aadfdab08fce85"
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
