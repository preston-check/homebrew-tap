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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.219/preston-check-1.8.219.tar.gz"
  sha256 "e54f296978d2330cd383965a2ecbdc3889f6838546c2e0202b64e28f6e5ce597"
  license "Apache-2.0"
  version "1.8.219"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.219"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7dad5cb1e829694ddedc269105ded1557e5ac29468682afd77b3e904e1a6946"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64f8c15ffee7634f6ec31c469a1402193274f2fcbca6db00c2bdab2b5945c298"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5ad565a281a320ffa582e374649b5d9842b18aa0a9cb695b2154ff676f1bf6b"
    sha256 cellar: :any_skip_relocation, sequoia:       "acf8af167ef3fccb3b450064a26ce22408def7a5972b2de1e881c033988159ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1efb5ff54a05e3921d8962871d5dacbb1c69d77374242c248c20fa4827717e96"
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
