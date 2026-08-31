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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.408/preston-check-1.8.408.tar.gz"
  sha256 "fff7c9ba0c806109f0fc04053b625cd4dbe71399d7b7f8afd59a41d014644bf9"
  license "Apache-2.0"
  version "1.8.408"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.408"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1115d4fe17b1b3c4cef402c07a20451e10b3de7d3b42b11a93b07648b5edd466"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcf8095d2c0c1536608bc3fda402c30f312432e055306d7a1854a1ac8bbe0043"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6213f2bd78790c543b33ad68149a67b80e6b1d90c18506f695668f0722e50ff"
    sha256 cellar: :any_skip_relocation, sequoia:       "b2ac49a7ec34a9d7ea454b32517f931353fe6ea1beea5ec4b1b40e866b3bf85a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de3f536cb83158abb4fdd92ac873af2c364b8087648c13a7c3f078abe1bab9a4"
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
