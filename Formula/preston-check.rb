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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.519/preston-check-1.8.519.tar.gz"
  sha256 "20e24130a74f4f37ab794efbf1707b7c41f16befffceb5abcddc9b8769522441"
  license "Apache-2.0"
  version "1.8.519"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.519"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69f3e4b6b1eab47998773daedff987aa76ad42693cb9bd14bea9be677c06cc56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f24c8c67f07282b9d9196009613c390052df4367b14be0a7c99ef416f87fe58d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "989d644ee45d96c23d1b6f32a3d91d65c997e29d48226e63e763dd9ebb3a6cfa"
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
