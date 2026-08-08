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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.260/preston-check-1.8.260.tar.gz"
  sha256 "9f7897a64275bd0bb78a4553ef407343242333356b952756c071da25bf704987"
  license "Apache-2.0"
  version "1.8.260"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.260"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2213227447002ff1785bed21701ecf16191d9cda21dfeaba07d3f1ff3ca7df12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec3410883778631a1e6fc69d1c81428a31594fa2d5f714a560e1d3e6fffec224"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d191e9d5d458fc16fcda0c2bcbd66758d695e9be8b8c4ff2c7cfc2f8f9c5e44b"
    sha256 cellar: :any_skip_relocation, sequoia:       "48633aa15e4477a065c46411e2235f1a75cc3096aeaae3cdd6a63fe6ccc84321"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff549c0dbc9b249101e6a23d40b97ae950442eaca550b8b7ff5bd7cc47a71357"
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
