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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.287/preston-check-1.8.287.tar.gz"
  sha256 "2632f5128a5ee660c47051c74be8fff99ec5c911b614db1413ba27d9c28fd06f"
  license "Apache-2.0"
  version "1.8.287"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.287"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab9468bfe65495f00fe8dcc551c4f05b562b25ed28d50e15fd5af07ae8cb9fb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed71088997c1bcc3017ae187297b8e6e643105b17d7189aceb45b8d7e2ad603e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5be89a1c57f9af9d84abf3b88578f6cff2411dfb812c5d8f9799690b7dcc7ae"
    sha256 cellar: :any_skip_relocation, sequoia:       "4c42f700f3cf5cda754b1f7379f56e6ebc0a6f13803f22b4d0290d1e00d23785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d3f1c42078aba7b454f24ae2df56fe857f03bddcd2cfeb844fa3f0e5d5cba17"
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
