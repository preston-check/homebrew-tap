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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.308/preston-check-1.8.308.tar.gz"
  sha256 "e51a0fd04c351045af9d2f6d7e2062228239fb8699a7409b2bc21a4be225899e"
  license "Apache-2.0"
  version "1.8.308"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.308"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c18c0aedbf5cfaaf3d51531bdc0c4323c28e8bb1895a8952ce0b0655053188ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a14bf83269217e3e995a4a3c3fb5b5ee0dce8e7f2d21eaf8d4a9da6cbe883fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da9c7b97a53f8c08d2b26feff03b03ede9c1cdeb9a4d7503b3377c4364ddf63e"
    sha256 cellar: :any_skip_relocation, sequoia:       "58799d1d92f605e5d28725c73af877aa06a8888106e8b0f6e775937be3364334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4abb81de40efdb74e55a03c36fa4696c3c10f643e132e70b3a7ca209410134ff"
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
