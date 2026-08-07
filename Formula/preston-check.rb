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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.236/preston-check-1.8.236.tar.gz"
  sha256 "d2bd1eaaa11b967702931fdb936c0948fce8e640adedc5e853c6a56aaee0d96b"
  license "Apache-2.0"
  version "1.8.236"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.236"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71f4a4c84867e07c3f3fb03c4e88534e5209ee7d3264779b6ac21646fa589f89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "728c7e434fea591f71c7519f01427c35a70faab1f9006c45ab20aa0975792855"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6e536998235302e86e19d79aa8e0696a049dc8b53c155347b868b3cb9854e61"
    sha256 cellar: :any_skip_relocation, sequoia:       "5d7ef01f8ded82dc94598f14956b9268bba5896761b0079344bae3bda8208cd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ee6b6e3bd882da65a1fb926b5caa1276b7e676d76f28ae9bb27dc69b2d4601b"
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
