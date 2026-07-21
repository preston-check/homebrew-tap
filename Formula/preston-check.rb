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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.76/preston-check-1.8.76.tar.gz"
  sha256 "6e422672d2101e2aa9038bb53d049321e04f35f24421bc13dfb2f4fbd23ffea1"
  license "Apache-2.0"
  version "1.8.76"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.76"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e396c082ba6c4719ef6425759978bb15cc3f4d9218e20bacdd3f3016a5396b9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28f3d0666c2d65fdb0994e9f7058004d4b96f4c475e585652b5416ba60635f5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccebb1991c4a4f6627865b1c113a5e4a15813b22929b6add8a8988c8681666d7"
    sha256 cellar: :any_skip_relocation, sequoia:       "80687a85b3bbe057b517aaffa703a8502d726e1ede286a67720e2a94cd52566f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee8a89386b886d603c818c59af254aa372f57fc65ec81225fbf009e62d9c5b97"
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
