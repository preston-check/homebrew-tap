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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.82/preston-check-1.8.82.tar.gz"
  sha256 "e0b7391c24b6ed09d88e0fa1e22191b11eac4dec6759d3671d8c87a47af13907"
  license "Apache-2.0"
  version "1.8.82"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.82"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "094b37fc2880628e15eb8989bc7b4bb38528024be6ff83dfabaabad38ea20b40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e240b5c84cb7926e3f103281f8ab23239333f3dcd0129c67fc3edb43a8c883cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f30086f17589b7397ecfeb8c9801b5e556e1f8bf843098e4126750483fdf8b1d"
    sha256 cellar: :any_skip_relocation, sequoia:       "55861751d05821fe3e04a476364211837fcbc4f7bbebb224500984e2f2f8dde9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7afc139e0f7b608f7d4656ce530802dbbc8888e8e4613db745e0e2b7a58b156d"
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
