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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.364/preston-check-1.8.364.tar.gz"
  sha256 "ee8101550e4d3ea4ed4bc1da09afd948a6455bbd24e2d06a13b62e6ec1aecb5f"
  license "Apache-2.0"
  version "1.8.364"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.364"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94bc8b288a7f1ececd56dcc5f16fff90e325b356472f4d9c32dcdeb2d07cc13b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ee1f99207cdd9549f039e4cbd2a71d279d1805c3fdc88e5240b59a5584834f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02f13c4fb5489c0e3cb99323ba975bd5ee8f45cbe28b336491364e595fe938f5"
    sha256 cellar: :any_skip_relocation, sequoia:       "583d5b328f08603acda03562d5e2daa89bb2d3e89cf3aff70064bce3c7758ce5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5937e7475ed789a88527c4a84bb065d17203e9d5f50f2da62bc26ec431deef9b"
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
