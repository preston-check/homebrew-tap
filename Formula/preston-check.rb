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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.224/preston-check-1.8.224.tar.gz"
  sha256 "cd4b8afdeea2612c09aa347f8f8eb0fc524e1ff0a62423919a3d0385f62946c8"
  license "Apache-2.0"
  version "1.8.224"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.224"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a625e2130ce3e6106e629d48d4331691fa55745c6c3c30f1eb33a9378ddd87e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "202efa9094c8347c0e1f837904e42c00abc578e019b55935590566b24470b440"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfb4e07ee115d86bbcf2bc52102af5d0603dd69821ce4ada1857d4738eb2b713"
    sha256 cellar: :any_skip_relocation, sequoia:       "7884a76c48f8488230d2d976d32977759b52f0a63f836213a0d0ebb359c8f80f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "551fe41a681770133bcb982aa3afad8df527758b3f6b33dbfe7aaa242e9a5cb2"
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
