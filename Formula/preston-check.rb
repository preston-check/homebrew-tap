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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.289/preston-check-1.8.289.tar.gz"
  sha256 "54de21723e7e6076bed917f0a27bd298ca0a852a95f7d9cc63928103c9583a8e"
  license "Apache-2.0"
  version "1.8.289"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.289"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49bf5f98440a55996aa855d1c2264ab87901dbb97289dbb4647c991cba697262"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9e02f06b6756d0b90e2cd921504ee5b27ef5e00b0554bb626184889b77bf5e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daddaf6dce13cc788131aeee17a241e85cdf035f30820cc6742c4074c68094f9"
    sha256 cellar: :any_skip_relocation, sequoia:       "21a660b1460a949a6b141c3ba098a882973b4a0a23072b1456b59a3fb530385d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d728f157a6aaf4f6b67697d82012a95a6f77114ce466240a8dba535be87eb978"
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
