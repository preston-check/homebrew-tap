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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.320/preston-check-1.8.320.tar.gz"
  sha256 "d9f69395014f1e6510c775c986e49edbdaac9fdcaffa305f2bf425e199fbf8ee"
  license "Apache-2.0"
  version "1.8.320"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.320"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae1d895bec5bf3d8b9f284f8881994d92010f5a7db55c61acb0488d735564612"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a71b76e03bac28725802a14d067d1f6ab242fb24aa7dd116da7f18acd75f738"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2c4b9b3d49d83b614db55e1991a7dacd3d4383f531190ef9098c450e117e3a7"
    sha256 cellar: :any_skip_relocation, sequoia:       "98c7002aa269eb2f1c1eb3bb2d889ff9f399e9d64fae6ded800f196dcb633ba3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e40a4e6dd21d8feb9051d2a36e7a4b9edccd43f49be00990fb6b831462b89255"
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
