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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.249/preston-check-1.8.249.tar.gz"
  sha256 "1907228ff8f4bd6d342b0046a7df5c26bd7bee3c30c7336f2356aba740d91c03"
  license "Apache-2.0"
  version "1.8.249"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.249"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2115ff121b0f695fc3e08933e65941ee71c5a9a7d71350874199603b70750d6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b480294e96787a2a08a77d3f9649d0e3fda47a4cca084d38c356c5ade7a9b1af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3691080ffe7ff64a08383dd1e98244509f274d76e99af6522b149294637b6dfd"
    sha256 cellar: :any_skip_relocation, sequoia:       "9bd58b270ab5e8a79d08095b8977acb9ddc44edd20c0c2ad541188430973ed6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd02045c53b96472a2092394b9efad44076f3dbb2ef6975570121c44a67c65ae"
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
