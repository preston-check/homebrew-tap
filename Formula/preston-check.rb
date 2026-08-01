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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.178/preston-check-1.8.178.tar.gz"
  sha256 "e1e23fc306078f8e8e70e61c840d7f3ac9a819060d46ac13947d5a331a48265d"
  license "Apache-2.0"
  version "1.8.178"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.178"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "596a6f33144bd13738a557f4c14089830af779a70aeee5bdbce95ef7e5ed6d83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eff6c3453ab76e8f68d92576cee6f4610211529bf6244c1e3a6b08e96966ab04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75bb1b437b7fee634b37cbde4d1f5549407498b840f9262cde815c9b8fb51b7c"
    sha256 cellar: :any_skip_relocation, sequoia:       "65d746479333b929e3c8dafff6a951662a583865e9a9cc6d9fbae9ba6162dbb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf11517b71a8409a6b33c0f68e292c3cfb002ee2af626f42d361cfb4c0d03259"
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
