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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.350/preston-check-1.8.350.tar.gz"
  sha256 "3cf8bb33a5c6f4304cab3d49dc4723d6fbfbf078f26e55b45614112c2c5dd49f"
  license "Apache-2.0"
  version "1.8.350"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.350"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f611747043db511ea0b676fca51dc8a879242a9946233f4f668ab6ed2adf13cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5215f410b02894b7bd9f6fc426b3886b6e86d0fd18ad594e7f25bce1f92b84b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eaf7647989fb037da76c9a5a18547a079872ba34b655fc30858f05cad1ceaffd"
    sha256 cellar: :any_skip_relocation, sequoia:       "70bc595880c5d01b25114ac565267a6a527e102bcb72a17c5e44185036fd5eed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74d98680e5eadafbaf3191ddae419233a60797878daf7935f61f8eac493b643a"
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
