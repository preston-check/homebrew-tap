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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.223/preston-check-1.8.223.tar.gz"
  sha256 "1ff24fda4cf00b46341e4c11ff41f51df6124ed6da5152309c4692b5be79407e"
  license "Apache-2.0"
  version "1.8.223"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.223"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b570c7de794a4c3f736358209f48a587dc5e05fbed83f0a0e1d556ecad40f43e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcd7276be9f1c54dff8c81332ee8c00012b63ff87faea70c936277e46639c504"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc2049943ca1d4331cd2189353783ff0cb038f7451d8cab71440776731e69bf3"
    sha256 cellar: :any_skip_relocation, sequoia:       "ba165bd0eda0186e28af182e75857008b7da17984a9db3c456a0fefe40c7543b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec88e0f72c496aba3f3ff5eecbee06d21bb39cc20945fb8c07bd716adb41a12e"
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
