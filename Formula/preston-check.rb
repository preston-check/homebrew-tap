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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.365/preston-check-1.8.365.tar.gz"
  sha256 "db5779cd682502feef396fc06958bf00ee21bd7e1308b9e10f11568c11d418bd"
  license "Apache-2.0"
  version "1.8.365"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.365"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b46420e0e450dda23003069e7a95c00c573e5307635bdd7a6f8fd0dd38ba19e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "740360f9ccb19f1943f0f86df3932f0b69a0c1a6f1b9158a7520d43d2701ab14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78777079162fef6c2f8d50b9dcf53d65fc8d7f91a11cdf8cc74c8bae6f525185"
    sha256 cellar: :any_skip_relocation, sequoia:       "2c8489e3e20a8e57dd0a4c90f8e9feffb39078524a155a58d40b2b902d2fa9a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14b22b8939e0653b5d99cd3e207593900ebbc688ac1cf1960a8cd36894964e90"
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
