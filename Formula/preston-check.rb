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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.127/preston-check-1.8.127.tar.gz"
  sha256 "21547cfc882ad0031133fa366046bdcd3202908ca826b4d96dc693a4ebba275d"
  license "Apache-2.0"
  version "1.8.127"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.127"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d2db9eaa92440561f0ece785fd3fe3d52877fe91b5f26f578a21ff5b2948244"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52b99e8c4bd75945adcfedef1655c7acce04d32d5261bd4f614a6bc826737909"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9cfaf25b12a6fb5cf3cb298dcfbd6fe842414359a5ed18f91f9538e4e31c0d7"
    sha256 cellar: :any_skip_relocation, sequoia:       "bdbc61dfabc7780cd33983089e17fce03114f3ae821dce3eed9063842cbd8aac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16c1d795d963c57e37a6738188d09f595009a6b15108b2b420f0294692a04f47"
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
