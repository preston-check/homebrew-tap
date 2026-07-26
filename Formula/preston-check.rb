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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.118/preston-check-1.8.118.tar.gz"
  sha256 "61963664d0d5f9536361e71bf6a1c799ebf346c7176d063238945f9485462394"
  license "Apache-2.0"
  version "1.8.118"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.118"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "492da875dd48f1d71abfce433705f8ae097162447bcce3842a059616e7d82cde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "451ed6d116bdf9ddaf29f1a4f01919c18456e37f198c0847004773234f031d9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b11aff86de966599deac408cdaee2c064a4c2b7e8eb3556dc8de180a2a8b5d7b"
    sha256 cellar: :any_skip_relocation, sequoia:       "0d0d57f48e41cfc32fedf2c6b760db130d50faed22108d259dc501f0c5492242"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7778e7c7afb355f41f9d66609383f85383ebd46ae24e0c97ff9f9ee76461b64a"
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
