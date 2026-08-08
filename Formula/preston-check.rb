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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.274/preston-check-1.8.274.tar.gz"
  sha256 "64518c8426e181595d02f83993ecd9e451935ced497024d0c1f90f436830228c"
  license "Apache-2.0"
  version "1.8.274"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.274"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06b326de7f8ceb537a295dbac0cba4ae81899d84821915167bb0564fa439c9ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b890ca43f5fe89ee21d795c891dec4a87f4110b232d8feda3cb3abae7815c1f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6006932634b2188b0a45c3d95a3ffc9d052edfa8600845d1767382f9a1d38bb"
    sha256 cellar: :any_skip_relocation, sequoia:       "65b33cfd7858dd1c38bb6e2c34c39ce1ca82c2dc76331894b00e3b7eba67456a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d88868b708272c0da076e56571006d7d685a44e32cee6faf0ff4e4ab93af6c95"
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
