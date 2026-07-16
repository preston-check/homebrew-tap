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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.28/preston-check-1.8.28.tar.gz"
  sha256 "8007a24ad7175125b21afa872d7d1605bdb1057ab8649b265b80e16f6d37fce6"
  license "Apache-2.0"
  version "1.8.28"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.28"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a2eab12c2b60854b0ef9e4354f8e803b4dff399cd55e35c3c0bf6421b5e3a3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2d6cfd13a0b9c166d3fc8dfa94ee04765d789b50102813ee0ccdfce3f383075"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd548237a51d782f3f789631468656e07c91b5a8361edfafa50463d5f0f1d354"
    sha256 cellar: :any_skip_relocation, sequoia:       "c3017c3b11cf99151398be3c1fc32d69fdd8f62146c73a19543873956a0eced9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58fbccf4314a5cc5c49db508ca67e90e910cc1c073c34d1e59f1f4e824ccfa6a"
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
