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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.120/preston-check-1.8.120.tar.gz"
  sha256 "3046fc86986fb2c1d92890373a51aaf59cd2cb065dce5142c3887f1aa07e571e"
  license "Apache-2.0"
  version "1.8.120"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.120"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "223da6a7e196c0a9a6dea7c34fc10c2552726d934ecf0a682787eea8611509a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b89286a4d5024e9c3f484d518c9d44892441aceeb7004c9f9d19b2657cf9fbaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b84e96d688f35443d4b3b56ac6bb659a047ed8557ae504cb6901fb036adc1f6"
    sha256 cellar: :any_skip_relocation, sequoia:       "405d9d31fab52bb906d57dd861df4035676f2fb2703f9752f16cd57a5851b42d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29aa7a6c2e4c3c72c29903ebfd6e397069275aa4e8c303063c696ce31bd66ca9"
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
