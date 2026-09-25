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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.497/preston-check-1.8.497.tar.gz"
  sha256 "90a9c81467011453ef6288154d79f7d590529f495aa71528be48d03b22679dd3"
  license "Apache-2.0"
  version "1.8.497"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.497"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04066fd59b65cf834eae95e5e568be489f43c61f60e9a6686fe8651ffc3a6491"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59a26ec8be47c3aadd7978189863855b6450c2b9f8bc61a10b101e2a7f42beac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1879145a406e390c70898cb8d790b942344fd0f80628282cadd22e26afa66bf2"
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
