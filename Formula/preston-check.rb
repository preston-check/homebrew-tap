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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.337/preston-check-1.8.337.tar.gz"
  sha256 "2c7f4e89a688e0536bb1275584bb6ab3f53238ee0c56a47ff17beddbe8c02bc7"
  license "Apache-2.0"
  version "1.8.337"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.337"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d5833884bd24f002c2b23a487e843bbdbff38bec563cd09f79d9e83a785a706"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cffe9795c3d5319023331e53cff10d4fc90a3a4c03637c5dcc2d3ebe23c793c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1242fcce3e2c8a14b1b474feb09e0888734a7160fe11115ac2eac7ee91c9f70"
    sha256 cellar: :any_skip_relocation, sequoia:       "056d453aa1a9b027f8ecbe3a5fba8c8a9bc2dc50b5d15e049550d2f1c60d2339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3dff37e20575248c543cd1c7d4474137d0074e52229d4ca13671cbd51077506"
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
