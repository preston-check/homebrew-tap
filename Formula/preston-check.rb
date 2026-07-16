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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.22/preston-check-1.8.22.tar.gz"
  sha256 "276e2e885b379e20859538484c0dc42661e141852e067f9ec7678606adf44642"
  license "Apache-2.0"
  version "1.8.22"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.22"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2c83a4f824024b267ab60c02ceb13d66db5ebf6a007715fda57b5d8c1be2ffe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "370d5dfc3113d0fb4bc484ad30cbe98fb2f7d7e672a8ec22ea0a990a76c48f0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62c5959a3c9e65361074888076f3cd809d4ad47b744b40d4b3351a386a2bf126"
    sha256 cellar: :any_skip_relocation, sequoia:       "3dc41882372711eeb895d3646aa501afa9f235d1b3d8f0f3950412f4356b5f23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cab7c1cdded6d2441aa15b5b53822547c5e98120b687c2b965d73200b91d0c74"
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
