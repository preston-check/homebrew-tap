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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.215/preston-check-1.8.215.tar.gz"
  sha256 "451449d7a3f2350f58e5bdea60f31b3af4421941f58265aa39f64a7952add3ac"
  license "Apache-2.0"
  version "1.8.215"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.215"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5192a8432c213a34879ad153925a9efa94d38e9a2c0dbe3e93488e96ba953a97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91b9abe2cd0bca45eea0d06cab4334449a71b0f2d479f4c445ebd07b39c5471a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ea0c446c9cf565760e8edac09e5cd0d00c32f85adc4c542dafc4a6e78afcc0e"
    sha256 cellar: :any_skip_relocation, sequoia:       "09f62a83f4ff6b448713740256612f238cde67238b5f88cf77bc90b4219e3320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1afc6b91e785408057735ca74e6eab97a62e542d8d9213d2deaedd431627fbfb"
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
