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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.131/preston-check-1.8.131.tar.gz"
  sha256 "9d331f4555adba1df5595388a3d8028cf881f88646c7feafe340feb51223698b"
  license "Apache-2.0"
  version "1.8.131"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.131"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44126b03bc7810fa67153874e0a11207e5915150f10cd7be56c21a72a0389eab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b98b06ab5290ce61042242e2159dd46d4ed30fbbbf3b84a0bab4235350c287e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6db182eb0b9d30218aaf4733de9d85a86b1a18b51f964f650469334aae3984f1"
    sha256 cellar: :any_skip_relocation, sequoia:       "569658c947bd195c5bcd341d51f2d3e5efb34fb770e65b092d4088ee6f4762f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bca67c7ce31da8de56e1877601e2f82ea69f64f82da09ac07e0b00cbdf1093ee"
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
