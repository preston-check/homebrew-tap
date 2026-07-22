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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.80/preston-check-1.8.80.tar.gz"
  sha256 "12540819920200db9e280b430563137feefb3d534821b7c0736aeeeeaeefc420"
  license "Apache-2.0"
  version "1.8.80"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.80"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58e00fcc9da062ec0817608050435e92243a2860fce0359d8ed2c4342a279201"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a8e898bdb34e4e33ad500266e3d1c03504cc507a2b66018ab622573956ba255"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "162eb480e6ee723c0e5e9c8fc54a49babb55eb1bac8410065120a3896ff8dfbf"
    sha256 cellar: :any_skip_relocation, sequoia:       "1f65b0ab05bdc0705b57a20222866eca4ed3cf519b31b6d547ebf0c510aac168"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7246b394e9bc248ab18ad70f3a1705bbd9e2d44d3b2d9d96cef1492a66e0230"
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
