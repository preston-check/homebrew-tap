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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.15/preston-check-1.8.15.tar.gz"
  sha256 "eb3fc86799905c4f64b3d62391132819379de3cf104ce38f84cf972eeea834dd"
  license "Apache-2.0"
  version "1.8.15"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.15"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b4f85fea59ca131774c11a4e1fc0ebac487d48a0ed1aad3d8b53e82b2760dfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3c3c3ac49c411a588e95f51ff4d54a89a5b91beac5ad81ae74252030e524ac9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "892b359e31be52e7bdd57b1f4308c99934095ed2e023242d2741439e36d2f008"
    sha256 cellar: :any_skip_relocation, sequoia:       "17839d6cdf48bfbf64fd33a22a096771f88f52ac20a5f296575b8f5f177e1548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "192203acae0f68670a22c2dbd980982a0d50ce44492effb5c9abe7a428bcad4e"
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
