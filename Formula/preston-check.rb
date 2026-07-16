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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.27/preston-check-1.8.27.tar.gz"
  sha256 "2eb674605b946a8618e880dea91f1a2ccb23cf45281a49f3038f44889d89a5de"
  license "Apache-2.0"
  version "1.8.27"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.27"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34f1771b416503dcb69b94a4b9936c0fa267efb5ccdd7582ca610813bb54a6dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e346f667667377a9c635a5254cadaba5f31403143009fc2dcaa152b9090d1cd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caef3fe5cdd2c37ab8240e32a777bf5c70456f31aa95195819bf752f7f8a44da"
    sha256 cellar: :any_skip_relocation, sequoia:       "50caabb29a2e1a8690eeced74a5d6e7fcd9f2d1f7494716553d6917f4611d423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "920f235c330f5fa4764321092c6926fb04ad805a3b2c6ec75013e2651440519e"
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
