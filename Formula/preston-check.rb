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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.33/preston-check-1.8.33.tar.gz"
  sha256 "52fbdd4777fb8e2ed76af01e7d87017bb9b8422f851368fafa28355d576876ee"
  license "Apache-2.0"
  version "1.8.33"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.33"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0eb1822ce95acc50b8d33b71d92e96dffcfd9e1c9ae992b217039ff6d70553c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32d08d7686397cf37583183c800bb2011efc06df14c80fc0d8d5a41502b0a88a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d3446674bf43792df07e68ac48a6c4b1507a30000d03b310884b19d2682475f"
    sha256 cellar: :any_skip_relocation, sequoia:       "4a724392e6a7ef274bfc126de8096f1bd279eee9eb598f42c802543ae3a8fe43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1ac62ce72b66d844b673453ec8f3b3765ec15557735beed622d757f3a6f9f46"
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
