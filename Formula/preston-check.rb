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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.250/preston-check-1.8.250.tar.gz"
  sha256 "f517df6678c7170de3f7343fcc51aec4e66be0a56a04994221d887fa96879441"
  license "Apache-2.0"
  version "1.8.250"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.250"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e9ec235177dbe0e12655d0578973781f553c45c074ce73000b240edab1ff699"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e43c3dfef080b5a988d133c852d2923ecd5e2910c88d8878bad129f691ec25e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49c463465043eb961c62df7f4de50a032ac19e9d2430e78f0aac1f40964d7f41"
    sha256 cellar: :any_skip_relocation, sequoia:       "998b7a716fd7c0ad3702654ff29821377b80fb7754460ea691f09b1c51957a64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4808f4b2c546fe590788186c936eeaccb2a0ddda5dbd25b7383aeded2ac4de1"
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
