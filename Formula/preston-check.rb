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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.381/preston-check-1.8.381.tar.gz"
  sha256 "a7f1714739be4e3f89d41807aef3939c20b30d809d9c70ec3d139160d92d85e2"
  license "Apache-2.0"
  version "1.8.381"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.381"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "276bf965c92f07c27bee59472b984f0e2480a49df632e657e6f18ede997f52dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd3eca2218f098dceaf52c127a28ef4110910638de9734e8dce8931e660f7884"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db19f33a211703424a5aebaf829afe22143e4c61a51f1bd3fd88faaf2e1935c2"
    sha256 cellar: :any_skip_relocation, sequoia:       "5b890f6c1625e33bd592592a81aee13c62dbe3dab1d9b39bbf22aafa26971aa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afb78cef143b65c3c3920b93ac1b5a484e0496cd2aa27087e7edf37b4c73f81c"
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
