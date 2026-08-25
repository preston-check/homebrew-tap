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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.395/preston-check-1.8.395.tar.gz"
  sha256 "514037aea28d188cc7dc4655c2d8d86b77e91964a1e4f70882b869345545b9df"
  license "Apache-2.0"
  version "1.8.395"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.395"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6da15660d15383a72bc9c7a280163564f7ca006a3f9fec406f8cbacb32136d4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28842c3a81811a05792b9c1e43b335a04e463f870e9152d0c06fcffa8a1cf993"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41b8edaacfa19defba8f221e9c803a471901e723536d3b1c26c3a9c9aba17b33"
    sha256 cellar: :any_skip_relocation, sequoia:       "39bd9b9a8a2859f3f60b8c408e9a426a490c391cb1b9e54ac887012a15b32e86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3b43ccb2617bd22de7a2943326f3516dedb1b433bb954b696bf797f5ac8ba31"
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
