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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.266/preston-check-1.8.266.tar.gz"
  sha256 "547cf0523069fa1d78576569a45e8bd2ef73789a898605b8d986c08f5c21a836"
  license "Apache-2.0"
  version "1.8.266"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.266"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cea9a91b51477fc359d4832770bbf36dab396a0f9e55d4cab8abcf6c28f05297"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed8caeb05ba127e54d26b2b0f5905e16ba8f7e2ae4d1f1fa77e2446c04063d80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "733c2235cc64d08c777d256000d3eb368a5fe5021c49b12874ca0d196e40b55a"
    sha256 cellar: :any_skip_relocation, sequoia:       "84e5f73a3cdac8cd64576247b7eda3713278902df8256bbc01c6f7bd70a6b403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89dff79d9d69894b73421aefb1280123575a5eb0d38f3d8677898f616b0e4cab"
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
