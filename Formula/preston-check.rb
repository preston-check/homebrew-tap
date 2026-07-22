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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.87/preston-check-1.8.87.tar.gz"
  sha256 "e371ddb4c3ec3abc7dbd7803acf0ac36416a1546427b8c6f4e09383e043e088a"
  license "Apache-2.0"
  version "1.8.87"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.87"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1a9dc22cda13023196f1f2775e6011b4905f27e50c03d0892614350d363f23f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2acf4f2bf138487b6941279a40930b5388d5251528655892e31bd263ec8f84f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f3a7cbee99b19dc517cf93cbdb321c2af9e8ad02e0e1a1d4151dea48930665e"
    sha256 cellar: :any_skip_relocation, sequoia:       "cf541243dddef59fbbacf8ae226a4b7a9266aa562d49d461560941583a1f3d30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5760d6178dc617dff96d426d7050b6ad5ee5b61ec8ae2e1890dc854adc6dc642"
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
