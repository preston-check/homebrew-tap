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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.433/preston-check-1.8.433.tar.gz"
  sha256 "7c49c8617b6b968a43b9387be10d52c718b527ee0ff25fa312e8b4badbfbb274"
  license "Apache-2.0"
  version "1.8.433"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.433"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0145a71d7c5670d9dd7c0b057da32436a2802415cdab7400c97ea99db7c4af6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8be176672c500cb9976539c68e899d4dc093c11184381fbe60442f0409f1da99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "872235e0165d5e250a3ad222a8e5e293c725705fe15a757ea84b5376ad8ba29a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "233bfa58c8eb60407bae8c99907c92743aeb2afd0a9602a4247cd528312e5c3b"
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
