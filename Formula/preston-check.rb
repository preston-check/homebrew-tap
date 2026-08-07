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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.233/preston-check-1.8.233.tar.gz"
  sha256 "55db5775d3d815a754abdc273d57ece9634891ba34c3a36bb99b3bbb8cb523e6"
  license "Apache-2.0"
  version "1.8.233"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.233"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58e75e3ab33ad1950a5292d2825a41a51e8d62cfc4611abe3b0619479c5ac2c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dc4f0ebe8afa629258aee368e1ddd9f3982433146bb5b94244163045cfef11b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abb60e0e19f5078ec53c63db52e37abdda5521dcda865bf519e4b6b88053b732"
    sha256 cellar: :any_skip_relocation, sequoia:       "110b007ca6d248560bfecc65d37a24a4aed4324aaaab56422d8672d7ecec6b8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31d8009f22c687b138d1ad435780ddee625f099e391a3694c0427f84671b4b6d"
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
