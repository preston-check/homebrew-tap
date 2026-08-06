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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.231/preston-check-1.8.231.tar.gz"
  sha256 "4f2d9115dfe266a987230a846c01972c9061a73d0ab7c697540fd2107f4728d7"
  license "Apache-2.0"
  version "1.8.231"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.231"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecc8aead600f01a7484e859969209b0e5a954081dc8bb7a557dfa8663c9e0aba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "032e187371cf1e05e94a0f472e8848717e58fbdf2c1f662f24f1fdf120accbaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5b3838af9e971a481edef8457c05e137315dcf51671a25979cdcb7d89cf7eca"
    sha256 cellar: :any_skip_relocation, sequoia:       "bd93325067b3f4f31613a639364c416219e97bd31f5d91443f5ae7032b149d3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be7987d5795f2793ca92dde49962ac1450eea4a7b7eb93333b49094e86453c6f"
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
