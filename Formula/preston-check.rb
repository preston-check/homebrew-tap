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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.490/preston-check-1.8.490.tar.gz"
  sha256 "75ef816086029f9cb7c11e06c3d6958ff1f952d03cd40f301848a333c9dfe12d"
  license "Apache-2.0"
  version "1.8.490"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.490"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bad78021892241d029fb0d90647e86224a938d1d3f8d11c30b979a9212e18466"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d879032f4b9120d1838112b8056553f1fc6a81476b608a24f130c9bebb614469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9471bdb287ff3009ee0f1c0c6281a5ffd09aa29787e53ec1f2706e0cf5c16793"
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
