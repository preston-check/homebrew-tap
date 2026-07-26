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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.112/preston-check-1.8.112.tar.gz"
  sha256 "d880fc813e1aa600c0b69866468f5f62c578f5cc7bbd315b45c6d1c99c20e88d"
  license "Apache-2.0"
  version "1.8.112"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.112"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ed998cf99f63cf29bb98dda099805b5e5d68b01475a8c403cbb6a629a9bc400"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15fc3a1bf0e9691de0409d314cfd20013e1f0ffc77f0d9c3d2708920d2874d4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8ce1573676659565cba30d3feaaa541535fbffea5eec1d9f8cfa36b3f06807b"
    sha256 cellar: :any_skip_relocation, sequoia:       "eca5229a8af79b02eaae59591f4971e8906213ec20a3bf1c52ac93383fc4b7d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6535c4d8a4a80eb0db2083b553904d8ced8701740f8e67394db720502701de2"
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
