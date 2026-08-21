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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.359/preston-check-1.8.359.tar.gz"
  sha256 "0888605105ce4048e7dc5d2c2e0783ac103a1b3f965578e2d1fb3837537348a4"
  license "Apache-2.0"
  version "1.8.359"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.359"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4bbbcecc03e1faff50be009f7356ddb704e8a0f3daf5ef6a7549cf3072385c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ee360747404e28f81469e260a5847db20b93a8c92f3f90f3ea6df52b9b83504"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8ed94c3cd21ab0970619249cd9e4f4047bd76a957a58da8c463e69186718cd8"
    sha256 cellar: :any_skip_relocation, sequoia:       "e2b45c15e715f2786c7412a527dac628d1e3e6804187044611e4ab22bc201058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17e295fdc8cb62ce24347d894c141b01d820a3bb4047dcf16aff7b52eabcbfa8"
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
