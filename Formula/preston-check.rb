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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.211/preston-check-1.8.211.tar.gz"
  sha256 "61f6a3d4aca9f03bbe3da52e96e452cc443c9eb945b4e38edb15a0f66e58106b"
  license "Apache-2.0"
  version "1.8.211"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.211"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d794183d5112b168bdee6d91c86a13f0392cad72498d81876449e5a5a104e7b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9421ee40d920f6896fff469794664899d81e1edc67acc36279fc692bd6ab9d71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ddcd202532cf7119e9c9fe7f472e1dafe0e17e4ee9444e5fc5e231f069b939c"
    sha256 cellar: :any_skip_relocation, sequoia:       "cc812b3a2d3ecd6b2b74ec6090b7ce4c81b89efcc5384e2c12941ed40151eb4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97d9dc6ec42ae8d16c8a74e0d918b82e6c5f0f5ea0c93722ad77880799078fa2"
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
