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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.73/preston-check-1.8.73.tar.gz"
  sha256 "6bfebe4b1fe624844fe47240d5f9adc6caa017b496d4302f7923aa8a7140bf85"
  license "Apache-2.0"
  version "1.8.73"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.73"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7810248cfaeb45019b769df07e68a7d8b964512088a4280e03863904748ec6f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60f98693e1543a7ba9dc51bdbd0df6c5dc9dcb59feb044a0ea3e9d41f5b80ce0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4a8c2d56bf511d3fc7484898c1dedf0e365b60cedd97a6482f34b347f2f9c56"
    sha256 cellar: :any_skip_relocation, sequoia:       "23b005f818df699fcdf5bdf02f5523c40a23210b0dfdd8e2e49a7c3685c0d5d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ff4acae81e311a0cfe6fceb671d0fd268b7bf43ae1c5c1386f1d1c716cf4e6a"
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
