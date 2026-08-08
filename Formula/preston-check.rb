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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.253/preston-check-1.8.253.tar.gz"
  sha256 "0942077d62bff8f14cd56a5934e0358127fd09d4992b57e919cd175a01e82690"
  license "Apache-2.0"
  version "1.8.253"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.253"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63659b8782bce208aa318a06685dd00aac7541e1c677cccf02d3ad2af4cb351d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "677f2d7f42113fecf9e05092357e00885fafd5beddbd4c8ecd82bcc19082ea56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "170526b7df8bd2f775ce134a11a266db8f831190286ad1ed4556c46536a1e76a"
    sha256 cellar: :any_skip_relocation, sequoia:       "22355d98ce48a7874bdcc5b43790cad6c49a7347fb6cafcdf657b27fb8e72271"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4055428c96fc9744b9f55667494765ed22190b2319015ab68446748163b6341e"
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
