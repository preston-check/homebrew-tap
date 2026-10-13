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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.543/preston-check-1.8.543.tar.gz"
  sha256 "8ed396b8585a69edceab9a54e1c1091c8932172177bb6b01faf443c0e999fec5"
  license "Apache-2.0"
  version "1.8.543"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.543"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ce0af124e2e38852dbd549a11147b3c79de75ef5075a6f7693e924a6a5fe84b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d17116894bbbbaa6c16fc780793a27558e470c7114cdf92be639f70e6e0987b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "184899606aef4e3adeeef8693c70bdea3868ed09e58c4be768f446f84502098d"
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
