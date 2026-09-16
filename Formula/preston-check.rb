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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.471/preston-check-1.8.471.tar.gz"
  sha256 "db9fc19aa7f44f496a5b5f8487a1d17aa89bd020d60df8ccfff1d7cf4a0374f1"
  license "Apache-2.0"
  version "1.8.471"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.471"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d90460642fcc77d0b1bd9438a1b8254f115a4b19c58ac6e8ec80da6a8e6c327c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3729a9a4b7b5e398f67abdc2d12da6473062727e7204c5cf4bd30b9ed32178d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "445d2caf5039a84507fa786e9b34ce2dfe20526194c3291bef8d799ef10daffd"
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
