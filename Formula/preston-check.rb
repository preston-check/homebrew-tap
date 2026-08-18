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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.338/preston-check-1.8.338.tar.gz"
  sha256 "7553428efd9e5a092c1b3d35a3e7bcebf60aaf29212493e7d24afb8c7d5d79d5"
  license "Apache-2.0"
  version "1.8.338"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.338"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1844d537c7c96daf865f11f649658f28d41f760fd35a74bb6e2ed5b3b51e164"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5812e7f6fbaaaae06549f928a411970c215cade0d25e735d98ced6b5223723ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6539cf983ea97b3046ed61b78c9d241e4ad2748b1e693f16fea01e2a975006d"
    sha256 cellar: :any_skip_relocation, sequoia:       "ebf40847f2c32fb7d527aea4e8ab0ae4a09a5bf960ef2ef50b9f1e7e32b64515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69bd61ba92af589674b53d7f1940db7b4d912ba0ef50457418092a7084096676"
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
