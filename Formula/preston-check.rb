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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.313/preston-check-1.8.313.tar.gz"
  sha256 "86dcba907a2572818000040bcf004746ae3028a0b410f73d7f0ddd27663fa935"
  license "Apache-2.0"
  version "1.8.313"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.313"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9486796929cfd8b871c9dbf63b3710118fabbf60959357ac94ff4462e6bd915"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5faa6bb59f9a6d860d36c66c70b1db1d775833b09f3ad0d342bc48e7110647d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f824e45fbd876e1bc7561a821dfdec52f8165c9937467ce7afaf324716e83a29"
    sha256 cellar: :any_skip_relocation, sequoia:       "849cd3eb79ff67c579f4fb24f2b090212b1c692b2b455b62a1c6ac5c8a76814e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d18a7e69f90a9889403ad024d10e9ac35aaba8de6fcba839e9fb8daa0fe4c98"
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
