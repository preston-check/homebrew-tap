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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.356/preston-check-1.8.356.tar.gz"
  sha256 "72341fa7f2f0384ff76b89f0af59808b7d3a98ddb19e006ed42757cfca86d5aa"
  license "Apache-2.0"
  version "1.8.356"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.356"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4d9130656203148b311113c33cdbacd9c85f50313b38a69525752113156fc48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7165e0492da42f17abd785feb7fa115d063ff47929987ea94d84f3712d43563f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad5d06cee40ab86e4f4f94924ddaca3b6c9261b53aa25b00eed0bc87e9bd7a14"
    sha256 cellar: :any_skip_relocation, sequoia:       "dbd8be07301fef7d3c4751a0891ec89fb7a2bb87b47ac49d643aec046a9db5ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d562fda49bfd669378a8635c2901c6c91697f46a4c5c2f8ccb042126dc84ea42"
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
