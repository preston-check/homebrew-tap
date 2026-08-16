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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.312/preston-check-1.8.312.tar.gz"
  sha256 "7b4088782e5696d81fd82bc01954a164d4697afa8c7f26a714cfbfd6594c2b5d"
  license "Apache-2.0"
  version "1.8.312"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.312"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85d6f79a4b479f268eefb815473f8c44ab8b7dc848ced8a85771803f628b5370"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32be46c868558b029cffbd68f8f681bfc4dce34cf24c5e48a783d66eb922867d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "998b843b5596a618f9ab15abb685b294db8b8d401cd02f832b751bbc524ab8ae"
    sha256 cellar: :any_skip_relocation, sequoia:       "395c24fbc41702d6680e019b7e60fcd0417cc60d6571bbd1f15998552f1f38bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a882ef459d0cebc3a3a07e4f54795c751cb46eeb354274ba00c23997377a652"
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
