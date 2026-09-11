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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.445/preston-check-1.8.445.tar.gz"
  sha256 "afd58554445a2d2c9583ae224f7b50667565a97ec6f19159695422b272240370"
  license "Apache-2.0"
  version "1.8.445"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.445"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed96415367fd9226ae6339f98ed11c0c06cbd5d040411343339861a91c170bf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fe0990e98f664908b27c2f76095f4796b4132b5a4322cee15ed8ba484891279"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c86be248c43acd01d05d7fa6086e3f8d9181adeffa29c0ac7d808111d54c7f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eeda190e519ded8ba2b52b6bb49221854c27ec71faa8270134cd3b553752e49a"
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
