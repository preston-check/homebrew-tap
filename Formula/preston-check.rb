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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.284/preston-check-1.8.284.tar.gz"
  sha256 "4b75c63f34706e0fbb9e0cd5d8b7e361ed5806adb3b199bbff6e1b3883d7854b"
  license "Apache-2.0"
  version "1.8.284"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.284"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c525bcaaf276f084092b57da7e396228f4fc02337cebf93ac423f5304cde019b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "750d75dec8ee6a92ed845035da74d84e65a6ea64decd0265bfdb54114f3b669d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4dadd5c719563c7a7d4caf0cc8b592309aa5606925639d940fea12e943386adc"
    sha256 cellar: :any_skip_relocation, sequoia:       "51eb5c4868bec39bd8fe8e98a5414eeb50170c80a33bdd740adcd9a137406a7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "395ba536d9da1d04b09cae6173f1057153144831a3fd961f857b0a9cdebd17fe"
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
