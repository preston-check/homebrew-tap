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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.8/preston-check-1.8.8.tar.gz"
  sha256 "704ed68563554cd35b29fe3ed328a5ce4b0139d0742856a319c5d763529156f4"
  license "Apache-2.0"
  version "1.8.8"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89f8541cab070f0f772fd7ae33995171c6a4483b11932553789572c418e21a7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c84550a9a812803f069cc81b024367f7ef890398fcb0d75d87efe9070bd117f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd511f462b070559953ea485dc629fc7ad84bd851ca2274838360d30098146eb"
    sha256 cellar: :any_skip_relocation, sequoia:       "193108514ed43ab7fc327e293f176b5592acaa6035442b70b429bd885ba63ef4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56ef4cc9a9cffdeefdc680b3bcf0fed645cdc490368e0d194d26331c6b04d8d3"
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
