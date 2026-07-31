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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.164/preston-check-1.8.164.tar.gz"
  sha256 "8b9360819a46c127a9ecc5b3d458a25afcae5f84a29363a50c5749425ca0740e"
  license "Apache-2.0"
  version "1.8.164"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.164"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "851b91eb152674bd3f6663b56a29c7d08b78a6aa7dbb3278aa6b0208942602f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "709a7df6a2b7ae241e4f9814b915ceb794869c5b83139756cd25a0661f26797e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed2f09557d9f2655dfcf8f925a545abb9b19da01cfe862c479318442b1924e80"
    sha256 cellar: :any_skip_relocation, sequoia:       "a47536f940069eec058d2a0eb3407b6f0064d69b12c0d5a3bd6ca1ec388f8c55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6fb4faed0c8026b0575afb12fbdc9fef13c3d1ac5d79a7b52ba897bc77ac677"
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
