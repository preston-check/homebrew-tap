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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.52/preston-check-1.8.52.tar.gz"
  sha256 "d0d1323f3801bfaf8591c28929bc6648fbc3c60e92513b7d7cd934bbfac26942"
  license "Apache-2.0"
  version "1.8.52"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.52"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd47f86709c4e5803c76ba27df8ea3b9c42bc2909cc8cecf9bab0ce3304bf374"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8af97f89c785b72d555dbb80d24073361b69c4600cc9c24bdd8f28845d73b54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdc76a923130f7d946fa22d2cecba7ee810d544bc603a4df8a328afd294ae89a"
    sha256 cellar: :any_skip_relocation, sequoia:       "ce74f790fce6620b14aca90d03ae806b2ac547b9451b9c7cbb6e43a777c9ac05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0589342fcaec6e7632f377d63c4b51eab70ed3af66ba920496c0d8bd01a7bcaf"
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
