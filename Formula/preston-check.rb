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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.130/preston-check-1.8.130.tar.gz"
  sha256 "31d024c934cd29634d1b38e65942814fadc69d6d11de1ce7fb9a07ce9e7ab075"
  license "Apache-2.0"
  version "1.8.130"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.130"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf5b598200b11c2a8c8371401b24881a186f3ffc2b83194f3aa664a8f639e9f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1a8725eb6af818006a335f1e3eb06fdc2d65a37d22d1923e2d7a1ad41d3eb6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "155c1c5553db1a08d276e3e87cc0676780e8b26553c5edeb0d9c0504b6b9f7f1"
    sha256 cellar: :any_skip_relocation, sequoia:       "db505c6a4d2f21fda5f899058b9bcc50bb85258621e62afe8e51aa7e8f16e7fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfdab9bb5bae28271321799a809fbd81fba1f02918ecc82e7f36d415c7cbe6bf"
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
