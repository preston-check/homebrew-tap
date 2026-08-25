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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.392/preston-check-1.8.392.tar.gz"
  sha256 "4a95181aa5f9dc01cb1662244c2a7af6d632956444cffa2357fa283af7fc04b4"
  license "Apache-2.0"
  version "1.8.392"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.392"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66b7731558270ad4cfb8faca53903aafa411418dca50a7fea95976ee1418013f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ad833ce609f5607a253247c70cc4177001e216b5da1beabd159b7601cf5fe44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caf1f28fa6a104448cc70b2e6f46fff5f9a57c51ecd7d73d8c0bf811b71edacc"
    sha256 cellar: :any_skip_relocation, sequoia:       "d7a12cb28f01e403b1c3ed2d0a47c68769b0bb52dcf96d018b7e6a64bd313326"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a44d56f9ee22eb976749338695389c65c1a7f0824050250ce869d073e88f60f8"
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
