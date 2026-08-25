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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.386/preston-check-1.8.386.tar.gz"
  sha256 "428843b18068967ec1e6a0ac53eaf528b6aaaa02c8859645b9330011247ab52f"
  license "Apache-2.0"
  version "1.8.386"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.386"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39eb7ee0d8c5564f5684a8f01c7ee7f281d262e26d605641384c7df725022857"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "858daa612e0fd7f12e40d675c36ee24fc21bff9867567564b02558c8a2f7d520"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e62c90611298b01235c47cc69b260ea6a0c641c861cb239a51ed1e33399879f9"
    sha256 cellar: :any_skip_relocation, sequoia:       "ab058064797f32d42cea4c12fbbbe3d989e2230e1f8aee72676b0d835822c9ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "636668dcbd80992fda6c311ffd202b2ca5a0fa484295d0019ba3aa74f8c07338"
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
