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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.221/preston-check-1.8.221.tar.gz"
  sha256 "abb79399b0e6a4fab92b6af87610e4a5a357b11dc60088a72cd0d361ef997149"
  license "Apache-2.0"
  version "1.8.221"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.221"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4ccc829f8aa0a1cf897294aeb7b1bf6cf86fdb879a9f317642ae5e5c2113a4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba18d90615de424259bd4617e19525a36a57df9b3b84c8f365bce9221d3274fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb4704a3263c37d5f5fc0efdb399513fbb32d12b13d1840fde2a0c16328576d8"
    sha256 cellar: :any_skip_relocation, sequoia:       "f144da1095fca8d7b8f48a914ac3dced0fb50f16792fc065a5dcf765f273c235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18d2584f02afc884ef514bf9aae30e4075e496ad1752f66a93534bc42ac895c9"
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
