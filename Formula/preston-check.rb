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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.443/preston-check-1.8.443.tar.gz"
  sha256 "9b087fd2b6570bcac7be55667f29855de0ca35de83fff2b152283e5c9e6be19c"
  license "Apache-2.0"
  version "1.8.443"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.443"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "249ff62d186f97b2ee8ad27929df47b6395b1385dc5be35dc0692fea7e16f8da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b86432dbbb6a92fd60d6fbc5ef2328d7815208f1a3c0bc2bbc16a9ca5bf15b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cead674c7afdd391355e2908b2f1af8545d2de44d6ba5c9f03927495171843ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5d3ee35fb23a2bf86a09bd2f6ec5d2ce8ac5fdedc3d8d4fc5c8f8780e0e7a20"
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
