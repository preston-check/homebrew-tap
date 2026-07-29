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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.142/preston-check-1.8.142.tar.gz"
  sha256 "25c95e5d5faabdece776f121e5a167417852be55c572b06dc85b3f1b8e732b41"
  license "Apache-2.0"
  version "1.8.142"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.142"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4092e14e793464f96043b6361ce3906d35c32e4eec9d4fb256e41dbb17e52fca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d05bf0111b753a9ca883cf1cbf2bf5b91d08974dd4ce4ee9d6380dc128bdcf41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7fee2d314e81193c360b5b1601d38ed4d42a70c55a637b1e0b9320cd2b0990e"
    sha256 cellar: :any_skip_relocation, sequoia:       "bfa6a72334da06c4638cdfcc671088db33286c8091615bf398d15ea3c6f8892a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0974c440b762bd5b103695d7b161a58aa31b0515eb5c3df910478076a983e834"
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
