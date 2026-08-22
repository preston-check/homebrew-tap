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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.372/preston-check-1.8.372.tar.gz"
  sha256 "7fe6fe0f458e7730c2c01721a3096a83aa0878b5665fa39754087fa6d150769c"
  license "Apache-2.0"
  version "1.8.372"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.372"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfab85843c71c65b98892a0e2f55e0bc26dc311df5b3035b2a718573cf86a3c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cc6eb4f7ede7781fe77080dc9e784e797aa0621258047ffd04518f89ae7706b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a9406fdaa42d5580c330b29d9020f9ba12308b14a48dba507dbabc3c0cb275f"
    sha256 cellar: :any_skip_relocation, sequoia:       "b0a8b2953777093349650b50aaa8043e05e605ff62341cc0a01a3448f42b4a89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ae8f4b31336d68f93280a76c13c3f81ffc9c233aa85c90cc2f4252dbe0f4d91"
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
