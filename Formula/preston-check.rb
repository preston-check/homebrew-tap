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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.495/preston-check-1.8.495.tar.gz"
  sha256 "ff827ecc5507c020c38eff090bca1938ba096fdcfc02dbfc71d4611836a94e4b"
  license "Apache-2.0"
  version "1.8.495"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.495"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a7613f99614f4bf61a3a175164d7d832c081e442109985799a1b6f0324b4240"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6c7041933e0450a6756fa88bc2131918235ed87f19c54c480ecda28c28adad2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "211581e59a6cb0b4b0e3579f8d22b0ed3bd37ea7d4e9aef0a872d4b15a053dba"
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
