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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.283/preston-check-1.8.283.tar.gz"
  sha256 "ff4da98d3743790388f9865f04df7352085c2bd28a167ae025983cef15e604f3"
  license "Apache-2.0"
  version "1.8.283"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.283"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2565d0a638b48de93a4151d6a731d6bf827fb7334cf86ead52caebac6cb17a4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e3859953273ea4b67e9ed96105416f98a22b06cc111b4137a48659888c8bedd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14b8a0046af450782d497e0a045eb138014f849cff0e03c30eed8e72a2228efd"
    sha256 cellar: :any_skip_relocation, sequoia:       "97b881f4637661c2607e32942cd632870ce89a9dd52e072adc3d0482aa901b99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ab9b438eba21cdbceac57fa6408bf4001c7b0003763ac77edfa0eb1eeba20a3"
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
