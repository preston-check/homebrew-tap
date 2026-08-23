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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.375/preston-check-1.8.375.tar.gz"
  sha256 "fdc9590e7ebc8f4b9f2431d9c91839eafbc9c98125c6892c0c1225f4d56fffa7"
  license "Apache-2.0"
  version "1.8.375"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.375"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb044ff65e7f4220ea5ad971a54adda83a120595609d1b05b6480fb1d92a5c2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3931fbd5c178d4474b1d848b68eb9526a684e4bb3786e35266d0e1addba6529b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b07a6db82f1e749249656737f43ef58ba7ac4b17929a74cb0836884227740ff"
    sha256 cellar: :any_skip_relocation, sequoia:       "d696ee9802908f7cfb7b1a3def8b64e325e9aaabc34a419cf7c4daf9cd50cec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88ce1fbb319bca0506571aaf52ade08555035207aa0dd9aaa5ac3227d0d200b8"
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
