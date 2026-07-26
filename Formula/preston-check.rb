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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.113/preston-check-1.8.113.tar.gz"
  sha256 "c8e22e3070ac1eff21f50ddf6a4e351c129385c6551f940aaf18a8cfee728648"
  license "Apache-2.0"
  version "1.8.113"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.113"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "026f7a0f37ccb2212b3274d22922db51b1d15537a0afb52645a42ce2045274ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "125b9f04307475c2d031b3b2dead54dff16830fbc6b1b16e66dfaf1cba5e7998"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2236aa0e01ca662d2a89df444d1b2fe4537c075c51d8d29abb542339fcf1fea"
    sha256 cellar: :any_skip_relocation, sequoia:       "2b25b7cd9f6e080d35d6745082ae98ce625eda61229172a194a6717522fb5f66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c883facd7a2aa408bea60c7809f0df2d6a024a3fc0dce5ec32e690e0034fc8e6"
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
