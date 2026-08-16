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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.321/preston-check-1.8.321.tar.gz"
  sha256 "bbf9e2d6c847554448edd56231c28752c695b1f752a52e45891ec954e66b38a5"
  license "Apache-2.0"
  version "1.8.321"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.321"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5eef68690b0173bada6cd865d381ea69241d5793f9bf91a521894708dfc600c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f189aa93665ef7bf49fc491e2dec5c9bd507ed2b753726730c0a51ed3488abfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d106144e48814c42e175699c1437ce9ae915232edb7a6a6b99fcbf37156a25ed"
    sha256 cellar: :any_skip_relocation, sequoia:       "32a534ec8f7293d8bf1b9805fa528ae8a1e364a72e8fbc8db453c0ad8ae56f53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a234063a1ba8ba493838d2c9cc7b47d0cb43f650fa3efe8afdaa4676aefc3851"
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
