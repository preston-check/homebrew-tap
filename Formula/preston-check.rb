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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.435/preston-check-1.8.435.tar.gz"
  sha256 "36f518a7f7794ddde4bd1c9bca72d7f62bc6f5bcc649df59155614a605dbebc8"
  license "Apache-2.0"
  version "1.8.435"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.435"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05aa0c1fa6d32482be9f135f817350382ac3589f6c3c16448c51085fbd16d753"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01bf8f96dc7e19268440e08b07179fa3f45a255ae705373c1a76999af9c320be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3386237aab287eef97da793d715c8156f9f11db208d46797a9262700af92befb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ba0087d21630b2bde6f3268e4a77b93ddc91a8fe37971f0a6f595a6f06f1765"
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
