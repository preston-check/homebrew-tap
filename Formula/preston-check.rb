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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.483/preston-check-1.8.483.tar.gz"
  sha256 "b84c43dfc78ee76415faf36841f8e439b9fb58d416975f48607fe858667884a0"
  license "Apache-2.0"
  version "1.8.483"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.483"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b437a0ccca7d14b846e73d9a6dded219c45e1382daca67eb07a9a43368320e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02d106f8aa84ac8ba94968c9bff27f51e912eb43353b6ebad48aa7946602993e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5030fc6f565ed16c356055c258e1ba0377d2eed96b99f8e431ede22738b6babf"
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
