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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.254/preston-check-1.8.254.tar.gz"
  sha256 "301e32fc571e1e189e2ad3883e38055f509189493bf2ad7a402df00e2f0b1433"
  license "Apache-2.0"
  version "1.8.254"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.254"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13325e1c17eb1192b8a7e27eeb2ff3e9533ef0168c24b7c1fab2b223b995dba4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dee4ea7f249c4380932824e88a752272e916ea66da24dccea34e1b784821d75d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a26065046c491e8147f550369b0ea68f58d16e391e7444bec54ca0f950197587"
    sha256 cellar: :any_skip_relocation, sequoia:       "ae58f75b94320e2f4c312113f67f6599326d17aca0560638c7c49676d49002ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "581b8c88629d8103aa4b445865a707605d7e72b7e44cc79e7948142d1286961f"
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
