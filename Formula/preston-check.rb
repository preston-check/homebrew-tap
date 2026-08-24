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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.377/preston-check-1.8.377.tar.gz"
  sha256 "95c4613a20fcb557f2d2ea5da6aa5eed446facece5f3b8528a6fee5465db3d9c"
  license "Apache-2.0"
  version "1.8.377"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.377"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de015fe92595f8e41e3831ca778fa2a1c007d42226deba9d1bbaaafc7f805cf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c891c053f7ea3edfbce4154d6c2d1116d2eb58256736bdd59f7a6fa5ce8e549"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8099529a99dc81f7056c8b3709296e752df9287fa077b173f244ac7486083cc0"
    sha256 cellar: :any_skip_relocation, sequoia:       "15f7b5b420b943cacbe6fa6ff47b9bd865327f622a3adeb41ad9e5d10dbae233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ffa60095f14850c9224cebdae492d9aaa83e05b6bff8e0ec72171b439ba9273"
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
