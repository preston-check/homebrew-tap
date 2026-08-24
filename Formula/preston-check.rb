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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.382/preston-check-1.8.382.tar.gz"
  sha256 "5febbb9f2556ab90446f2117c95acf75bb865a11159fd4259d02fbb323334236"
  license "Apache-2.0"
  version "1.8.382"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.382"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8490c6d0781c4bd2a5d1e4760e972c9e0c46433f57bc81ddc1e50a2c61571245"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e10260538e86b808d6abef4cbd7e277762ec3f6d134c95ed30e9619c13961a85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5a8ceb42967c8f7372a2fb55bc56b1bc442548f6a85c1c9c4f8779b1051696f"
    sha256 cellar: :any_skip_relocation, sequoia:       "85d750011d05887ac92f505aabc6e17dc5f2962b17ffc882038ceb5f75a87fe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab848715eacf4377a51a7b5d2b45b346cd6ffd6c4b3bb3a18ad1aa8460f4f1c2"
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
