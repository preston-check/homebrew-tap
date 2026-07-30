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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.161/preston-check-1.8.161.tar.gz"
  sha256 "f2d2b897290481bd727959ba113539ce007e89b5a02e761469b31cc5c49f2bf7"
  license "Apache-2.0"
  version "1.8.161"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.161"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13cb9039d92499efac6ef4c3cce2cc764b5a30f9a1e7bdfc303da2f03581e38c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04d459e85da9e6bc210b119b07198d39fefe55b4339ad2844e91c0c210ecc4fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "668afc2d60f1ba105fef419283e4eead91d9b5fb178f782aeb061efd1eb02f7b"
    sha256 cellar: :any_skip_relocation, sequoia:       "c515f64e88eb1d4d8fbb316d59aa20bc9720cbd2f13216876bb91a3627356aa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbfa7894a5fdbd4213509a8a1602ad18655ce2cefc13e130bdd85616178efc96"
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
