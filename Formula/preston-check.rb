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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.12/preston-check-1.8.12.tar.gz"
  sha256 "3d876173db17bf2eab92916d01e2ff3e76be5180cddadc1a4574dcd26eadce98"
  license "Apache-2.0"
  version "1.8.12"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.12"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d043df83f6f58a0c5749dce871bb6f26b29f7ab80861e150ddeb372441ea7ce3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27fee80fc0b92261aef3d2a4d076dcaa521f423c56f911cc405fcd1b22eeb998"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de9e81d6021568e5abf3301a3e1945a9283e283d2218825208257cf121b5a8aa"
    sha256 cellar: :any_skip_relocation, sequoia:       "077edc305cf5a25a7baa986ccd6892ff2c97456d09f3938ad38d92b788ebc7ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a88c4420a03f8aa2020c53ad0f0e979fe343e840f5b823f4ab52a70dd9c693d"
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
