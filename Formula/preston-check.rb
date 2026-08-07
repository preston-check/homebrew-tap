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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.237/preston-check-1.8.237.tar.gz"
  sha256 "048f3ee1db333b76df2d06de690a044933b3797e477f52bf2b1ead23d8a43828"
  license "Apache-2.0"
  version "1.8.237"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.237"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02bcaf5cd2c2999bd7ef939a1ade0c3ab27f9fdddbf5c0e671755fdcc9ff74aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fcf5ebae9ea797173ee14e1df16e0c726b9dae301d89e06b3e3b015b69d2032"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b8be29be113da239dc346297f31c89e27c7489ed2129aa7e8d8cb529a42ff59"
    sha256 cellar: :any_skip_relocation, sequoia:       "44acbd8e5ce9ceb996990627780a37997ef433c6ada08b526f2891408f5fe092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45bb207d32d76c46544feb7a2fe849715a9528c6582bbc21adef74350d125745"
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
