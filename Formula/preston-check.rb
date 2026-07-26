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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.109/preston-check-1.8.109.tar.gz"
  sha256 "04d43f7bbd9efd345fd3363b1697fed2c6366860232e11234e0f3e0eb1f6c480"
  license "Apache-2.0"
  version "1.8.109"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.109"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f9d83fa1c0430deaa270f87faf0cfb027ff63d75fbedc9e19f459a03043488a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a44ef0d0e09bf9f1d0a01033031d242e8cb21690bebfb7dd80e59d9c99caaad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2871b53ce0ef881d5e18b4673e0e70a5dbd5488178fe3a64fe6c9c0bd934eb7f"
    sha256 cellar: :any_skip_relocation, sequoia:       "82384407723f6dae755a9b87b0bf599af14e8c2498532a56c74be562f69ca9cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7a7f6805bcebc3afff5ad0af3fb152be389e70d802a01f409147c752c4a5909"
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
