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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.241/preston-check-1.8.241.tar.gz"
  sha256 "d351b16ddf0a72c9506636105154eb82f3044c70d1844342bdeb00035f53e175"
  license "Apache-2.0"
  version "1.8.241"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.241"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "177b0e6f4985b6ea1fe5e2f2ac303176dbe7cf30b2ae1be7903e1a75d69316fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "411e8ebd1b58c29f671c7014dce13f2c7a8c8184fd5376a0d298706eca860cb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "982cc8d0a92a73d1b6a701583a590a3a671f40b01a1a44595b24146b45deae6a"
    sha256 cellar: :any_skip_relocation, sequoia:       "1ef6bf4889a3e878f478c3e9442678a73b1aa18e9b48609effb3433d2c8cd191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf0246a410d0c5dbb9bc2cda9ac60dd03006a05cde3340a7324a1b9b95fbaffd"
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
