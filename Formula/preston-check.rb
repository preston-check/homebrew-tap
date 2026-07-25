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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.96/preston-check-1.8.96.tar.gz"
  sha256 "e1dc9202d94192344e6f4fdadaedab713cca3429ca25459d0de3b2cea84555ee"
  license "Apache-2.0"
  version "1.8.96"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.96"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f5519b687d9566b6523e58068a281cdd5bcc9fafa853392844a32dd66685b86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8565956825de08c5b7f188073f6f31a52cdb3706cae7c273ab5288fea42f354e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00775fd97048b08bf67445dae0485f90f54f552f11c60aa2a2ca8defe4cf8a9a"
    sha256 cellar: :any_skip_relocation, sequoia:       "f4a4ab3367066b8038be09c408816cc1e42cd12dcb994efebe816361d6cfa2bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e3e4a444909fe3697ba3fc50da66965c82f0736448ed65d01d45c7852ccdb8b"
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
