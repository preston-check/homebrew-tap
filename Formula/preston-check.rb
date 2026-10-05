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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.527/preston-check-1.8.527.tar.gz"
  sha256 "a8b96d60b44bf15844218a1912dd54a1e029be80a79a4fece76190e4c439efee"
  license "Apache-2.0"
  version "1.8.527"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.527"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5600840a3a2b8c1d53e3963b58af8fd9012b22f94051eba04719966755b01f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f42ad9f9bcead246b91b7db4de2548aa1ee2ead72539b2367ec9bdbd57bbd4a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd02e4e24e05da9db65c6fcc8ac5a6600b674f107a85ec8809f7e98a13020cb2"
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
