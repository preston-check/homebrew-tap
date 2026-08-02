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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.187/preston-check-1.8.187.tar.gz"
  sha256 "d476f47e96489ea95cf3db678168a3296d5455429341a9f93a0e829338e33de6"
  license "Apache-2.0"
  version "1.8.187"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.187"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4cdb7bb5df98fbac038e6160ba0431ea76d6ceeebdf63c7b7ede38eba983155"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a312c40312e9f6a9b615dfea9e3f61aab456620eb3c3ba8fd245178e3ed4bbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b9b2166a9a98929a7535171f9976f02a07b9e976d8d3dd554a0389f2229f3e9"
    sha256 cellar: :any_skip_relocation, sequoia:       "0594801ea5bafacf783dde42efae5ca53a30b25bc377883111eaaa75330e6db3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "942004dbf50de3d9ca35a479ca6188a58684bdbdd61d49cc27c557eeecb24a1c"
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
