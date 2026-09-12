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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.453/preston-check-1.8.453.tar.gz"
  sha256 "afacae779b2c61e11c68cd36caacff712079ce0471c038bfa2716aaba8e9b36e"
  license "Apache-2.0"
  version "1.8.453"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.453"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69dccf35fbf18597212f5955ec8127a51e3883854a80244c3d8ee435439ee1f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e73fa84b13644a935db5a4b1890e49902de6c95f476e47805e09eb483fe4472"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c111155eb483c09dd602ca216614928e488e61272cdfe84717908b55466b7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "293f5b9435bc0d0dbe6349f1f2abec81dd0819e886893ba2d5947a0d786bdc05"
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
