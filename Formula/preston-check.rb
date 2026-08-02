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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.192/preston-check-1.8.192.tar.gz"
  sha256 "ae0a2a21791cc13db6c2972f58e39748411750dd273c7cf7e8443678de44de75"
  license "Apache-2.0"
  version "1.8.192"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.192"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "360dbde194b5c51935222c6edb5f8c2ec876ca7092bbb4c917b0241569b4822a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f0d5a7e51ac9a57d4ab3b81a691cb4871dcb979834e92dfc7b366bbfc9d5893"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "272c0a771aacf37d9fa0f166c2fb65d161f0d29fb3bdcdf5ddad4f15aa8e1b39"
    sha256 cellar: :any_skip_relocation, sequoia:       "cb41f39a56af17a082402b2ad31855386ac38d399320db530ab676304341ee94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cec1cf67d02971bab0f40a5a22887fae5e6da4320524d69ae254be7bf5b47cc9"
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
