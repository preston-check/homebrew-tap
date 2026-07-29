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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.140/preston-check-1.8.140.tar.gz"
  sha256 "f64c6950a4ec73af8b53f56d4e2ee64fa628ec895c48b511feb0439297bd9725"
  license "Apache-2.0"
  version "1.8.140"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.140"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56a9dd4e43eef427d3e1a0893a42c3de377455d56a827f04a82c21a340158192"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54a8ef4e3732a8e651e6a4876e7238896bb8f4c2cc6c6f34dac6c93522eefe6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8a7bcea91137fc790b4192a9fd6dcd83fcb6883ca4aa0c3f5967425a453f14f"
    sha256 cellar: :any_skip_relocation, sequoia:       "a64fa1b767d7e5186f702ba956973e5c9abc9b6d9614cb6cf7d0b8a8e9a53ae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca8b8f92e4dc70edab164eca4890b53859bc86cf41e42b2309a5ed4bcaad80db"
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
