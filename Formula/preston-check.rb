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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.150/preston-check-1.8.150.tar.gz"
  sha256 "e5cf0a0c634bc190bfc22c83cf52038b873717e6ba7477150542c9a3353c1173"
  license "Apache-2.0"
  version "1.8.150"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.150"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7dfdb1ead96bd96b87062ffe4f2fa52211b7beef75389124ed02eb61689b387d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "522d0832ac44ac1c28f53311d0fbed5c56e0679a9620d8db980b87d0bf7bbb85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "580e31fa402ca18de33a73e6ca3fd3883d92672fc44531779aed09c31fede796"
    sha256 cellar: :any_skip_relocation, sequoia:       "b2817ff3587f74acc634ce534afb09035290691cd0b87d1f1ebb836f90aeb079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18613d1616ca875b2897d5885adce55d5e066eed717743c73c1460d5e9e27fac"
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
