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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.103/preston-check-1.8.103.tar.gz"
  sha256 "18f904ffe7b7956db3854ac151b4df2e33aee86d3486ce0d0fdb11832b798107"
  license "Apache-2.0"
  version "1.8.103"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.103"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e414e4bb5896590c402e11a074f07162a5e33f623ca60592963c286b73cb611"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbf983b58703274d8e82577c28c7c5986d60a15446fa4f6e4839ab503233ce8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbb4b7005c84d6f2c67e390819606655ecebd9c55987846499933acebb9f6c79"
    sha256 cellar: :any_skip_relocation, sequoia:       "3ecd15e18dd6d07727b1c13315b16f48362441d982b93f106fd14f3ea91dd51a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6395e7631384bb8bedae9159eb0256d42fef5ddedea4b8a86fb5d8d5a8f3e88"
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
