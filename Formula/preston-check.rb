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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.296/preston-check-1.8.296.tar.gz"
  sha256 "f338c0230530c4e7ba91629c3f5adff74f6c353157eae1171973a82942bcf2ed"
  license "Apache-2.0"
  version "1.8.296"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.296"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3152080e1b587a7ed0bc59e33a1ac7cc6730b61eb03a04989c8c279f5ce17d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1877f4e9587f50f4749468b9ab395d3d3468a728c388e816ff6f4781955e307"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8da88403c50f01e7d33231d8d73540f6922341215a3319d14ac483efddaac315"
    sha256 cellar: :any_skip_relocation, sequoia:       "cd0f2880a1f1c73ed44aed1aa0b5e855c2e6d3b322f7e4693c0091545fa7b26d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c5c4e3986bea0e36a215336bec73e3b4302c595c85892bf4981e97d23d0e332"
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
