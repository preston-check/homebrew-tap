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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.180/preston-check-1.8.180.tar.gz"
  sha256 "dc326fa265988cadb9377b9588e6b2908710d38921f62f9751bf55c6258e770c"
  license "Apache-2.0"
  version "1.8.180"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.180"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbbcf30290ab7e1b547f9bef5148e21336e1fa931d4da274e2b2ae037bacadce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfb3b2ba9e14234fd68080372b3cf4652054640f233a1c038d0e5251306f5b42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "626218d34a2f3c47e481ef1cb65814158727692d307fb9200ba38ebb5c64ed97"
    sha256 cellar: :any_skip_relocation, sequoia:       "4240c6e69a6295e4af96c45289b2286bbf0a578fe7760b6d7230232704426b39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0e556121ca2d18f85ea40b58450c9ea35080226c35905675f1c1b9a3a51ae01"
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
