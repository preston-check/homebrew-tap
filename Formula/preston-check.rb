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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.324/preston-check-1.8.324.tar.gz"
  sha256 "142ba3d5bce76e97433e9632fb3d40a4a5f6f7a332eda8aaa971ba9515b58413"
  license "Apache-2.0"
  version "1.8.324"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.324"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3dc91abc1677bcf37aa4c09852506cff8adf9bb45b19019eafd5753448e19714"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4832633127613740695000aeb251420a8959931687777fbef9adda5f910f9ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c237ca36c12bbd2d8f5ff1974055ef0cdf4d5d3c7fda2f45cc9842d99097350"
    sha256 cellar: :any_skip_relocation, sequoia:       "7d4244b868628c64a5795398355ee675c964b0bba7630baadc2d9949914838fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5de27d484214d56c27a8bca45c4ebe2ac4f3f90797449d8683a7553277e810f"
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
