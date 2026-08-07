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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.244/preston-check-1.8.244.tar.gz"
  sha256 "3a91bd2834023e9d8d8bf3e71ebd1e2c3ab9433d934556c17f06d7337e66a80a"
  license "Apache-2.0"
  version "1.8.244"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.244"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d5991a2506d0a52b2f5c9e9501fe918e0acd13c3a9397156f404f2beb08654e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c054853fb69676de9b027da94bc93843d787294d1201ddff9c66cc2fdbb0c9a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8903cbf29a45e6d0b9f7697b51dbf7e9db6a9587d8dc76788b00dd0f5e66ae9"
    sha256 cellar: :any_skip_relocation, sequoia:       "6a7a9ab49bed4c17d817bbde4d571582f62f5db933fcd65bbda586271de204bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46562c62cc43f6fe56402fdcb471ff1fa66c98658a9bec6c14ac39608e42cea3"
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
