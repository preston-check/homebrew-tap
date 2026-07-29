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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.146/preston-check-1.8.146.tar.gz"
  sha256 "a1c9e038435ed8f54cd935a4fec51eab8c5482b592a9ece936a4433d77f3c710"
  license "Apache-2.0"
  version "1.8.146"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.146"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9aaa2d625b629e11bf074ef98a4092430701a1b193d8933fac05f86b069535fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cd164771ac95bfc48e07ff30997a4d8bca3b566d4f19f6bd33124287e0db56b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7957ef238c4a5005eb932dd3188ea20edceaebd0bd6ae6c75596c8c3b86d294"
    sha256 cellar: :any_skip_relocation, sequoia:       "33271c1d383deb1156adc7a3de4866afcbc2758f1857a39c6ee2bd494cea35a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34042cba6c2d3d57fc630de87463f47c5501cabb22159dcfd399bc032ae6876a"
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
