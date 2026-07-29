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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.141/preston-check-1.8.141.tar.gz"
  sha256 "271da8dea5bc71e9a71a2ee919b9126f5e7ca83f55a8b4fe18a198ab8db079e6"
  license "Apache-2.0"
  version "1.8.141"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.141"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e474aff6f70ee9bf5b4857d1752d09cf40ce369fb47824c42e476cfb8c303e5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c4354af2267b4dd9dbd52eabc0a6e48dfc43f5f2cfdc329d4d671ffc0a76a69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61c94620b01043862304bae3aa75b5c4fdb5ac849c5b5e482ba8701b8169ae34"
    sha256 cellar: :any_skip_relocation, sequoia:       "d81c4ff15312801332c212e45bb7592304ab33ba652bc4bd0a5a08e865811865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edfea3accac013b2f94b0b750fb5fee27ae3783ab901db4892cf829c2e05922f"
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
