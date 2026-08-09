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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.290/preston-check-1.8.290.tar.gz"
  sha256 "6e89978ed3384fc68fbd971936532eda79f8a1e1d458520304e80072aec3bdd0"
  license "Apache-2.0"
  version "1.8.290"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.290"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db4dfc8cac6ba97b8058482b8744308ec4301858b7c57b23359445541ca330e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e9090ed2c3527648ed9eb59db3682a03c53cfc536e6f99fa1329207fc333905"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca8d171d764b330546e5fb3a7d43d189bc0f7133ab59ac8481add93c758ef1e4"
    sha256 cellar: :any_skip_relocation, sequoia:       "50c920beef9bf5372c8a26068446f0c971f5715f3f2db63612b1e0055a46e6e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4de9e68962ee6a7f5221d2afc3e8c9b0513ecd7146d982d3003dd56101c4753"
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
