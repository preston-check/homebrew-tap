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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.226/preston-check-1.8.226.tar.gz"
  sha256 "44368bd66cccee942bdfb5f1387a3ad55ab103c02e7fe3cda7044a486a90f33a"
  license "Apache-2.0"
  version "1.8.226"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.226"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "859022702ff4395f0b4dae6f900475d34275389e8e5e9fdf180c47daa51b1916"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "588d2081c4965cf9382857a80f5e1afce5237be8390e0041c7b1d6a335292dbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a0d852a6fe51ddec95fda929527e3b457c9211db7573ff0388365ed86569799"
    sha256 cellar: :any_skip_relocation, sequoia:       "38b554ea1e122ddce6d554cb554c967931714894bced9a26608407b287934661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bdd6443956c06475f8078e06d7a2ab942887dc59f1139c63db388e3be306426"
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
