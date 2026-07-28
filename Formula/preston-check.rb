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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.134/preston-check-1.8.134.tar.gz"
  sha256 "efa760b738d5db3a103d2964127548d6f4b90d2b569c3e253e6fd21866b39701"
  license "Apache-2.0"
  version "1.8.134"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.134"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69c168b9b4348aff0537d93e1e56079a6da4e66d14774815d60b3c17828a1b7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cf8aba1df7984609f6aeb71c7fadad0c3f6b59d8a88b40c05f91451a5b3957f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "296c3f529991dd0259bbacfc797a4280f4d8507ba4e9b0dc33ae9bc4807a586b"
    sha256 cellar: :any_skip_relocation, sequoia:       "cd71f03e91c57818c34d082f2519b5c55f26b22b79de93279b3be2d59d4c5639"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1035ebc8206e34c451427f2b6dc2dab99785f40748b7db1fcd7e5af617788336"
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
