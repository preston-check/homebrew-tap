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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.227/preston-check-1.8.227.tar.gz"
  sha256 "0e679d1ccb7a323049efae3c09e3e397153b886eabffb4947f1858a07d84d968"
  license "Apache-2.0"
  version "1.8.227"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.227"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ebc542fffa878e2a5a17f5ddf06005b119e40815deeb7d28a99f66d668bf7de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aea9814b3df1bf55fd07e0f4591e6e95db390316a833eb564edada465272550b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6976f39c040df067fed01e470179fc5282cce2c5236c8eb1d6b68b2467ce3aef"
    sha256 cellar: :any_skip_relocation, sequoia:       "aaa4891a4e8d7e681a766e59dc4afcdff3783427873bbf8a8f9bfe92ef7dbbd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a092e0da23c3c5b4f721ded0aa2b8f7bd7f188c55d10d79dd8da18bcf47fbde"
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
