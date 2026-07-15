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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.13/preston-check-1.8.13.tar.gz"
  sha256 "6a02db479e3cbdf54f197e4387d690fe46017404d0283f930e1e74d18b5ae6d1"
  license "Apache-2.0"
  version "1.8.13"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.13"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f160c58b7d7adada5a1942caba5aef2ccd5ab8a73c7b353b66ece18b1b3203a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e098f814e2c071e76dce6a1993c893e0c91b199844a9f2c69efff8b7b4b1c9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebaff3c420783ccfdfc8c31053e110fa6bd2bbbbc09d78c49214afa236cb53c8"
    sha256 cellar: :any_skip_relocation, sequoia:       "211f959c2a25023d602bde19cc8fba6a9447c2e47bf8482201bbf363e74ded8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8fc69a09b7d4e62274644eb51fa7b050886c90fef832939466f7d30e1243c4f"
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
