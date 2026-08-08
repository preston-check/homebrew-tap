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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.277/preston-check-1.8.277.tar.gz"
  sha256 "faeba308558295a26b0edb1731c5ceab6cf6f0d409d9c20af5cbf1bc77292c82"
  license "Apache-2.0"
  version "1.8.277"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.277"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "815640dafd12af65601d426f5524bf99f6654921b0da779b11774d278948c023"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23087091759ae38b3adfc82a461066d48f99bf69cd46be1aa17ab519a48aa9a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d922c057960ac154800542e64c4e98e1ab1dce6a253fb4302eda10bf4a4ba0c"
    sha256 cellar: :any_skip_relocation, sequoia:       "a1267704c150f8dcd86c2a7ec8de92dc2682f519d5b37d8badd53bbab0f586f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e07df412aaad8d658af739d69e6401d24eb0dc18c1fe82974156b735ee5433a"
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
