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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.206/preston-check-1.8.206.tar.gz"
  sha256 "bbaf1b39664d39f10a79897f4d33280814d20055446a7aa6db88283fc659f6cf"
  license "Apache-2.0"
  version "1.8.206"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.206"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a89b0837a16df0d9b92756cfe083bf074b7786e3d728065596550e58c9cd83c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47caed4a100d810570fb456ce6f0aa0119553ce950e067aa80d47ec589156469"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "677332fb4ef39f68b1549a81dd6d73176655467b962448ded82a38c5c5549332"
    sha256 cellar: :any_skip_relocation, sequoia:       "1d99eacdddd2f2c57f25f287df1474b39f50f1fc782e8df43b91bd9c72c10a6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d5bb688ed5bd7b43f41ff1b376fd7537fc05a53847b6e7b5757917e130a0bde"
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
