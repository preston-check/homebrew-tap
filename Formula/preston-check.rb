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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.257/preston-check-1.8.257.tar.gz"
  sha256 "65da74cf538293eac007f84fb3f79e4a8e73cc9f06aa6af7a1135b97b3241143"
  license "Apache-2.0"
  version "1.8.257"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.257"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c908a8a2f8569d98c47f9a05a9c10f87bd8deb09c93eedeb9b8653d7286263b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2f7c6c8d7b4e9fe20ffc2c79254d13f40048b9bea163a807318d96204098564"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57d800a382d06e96b22b271d1f2b2d2a253a12f962f36b8f66047a3ec42379b3"
    sha256 cellar: :any_skip_relocation, sequoia:       "111383c3e9f02d7abdcea4679ac49adc349948947cf12f9f3639710cd7a08929"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "908dd474d9e273e095aef13130bb01fd65fc92354a32bf6198f287715f4aa0b5"
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
