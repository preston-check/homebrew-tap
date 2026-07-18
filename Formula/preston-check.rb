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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.55/preston-check-1.8.55.tar.gz"
  sha256 "bb8c3d05e9b45f4cde90bcd7d1426a1206ca17b4adee5bac020f773a6bcdfb21"
  license "Apache-2.0"
  version "1.8.55"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.55"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afd7da6db563507a0f8caaf944e4a555194b3ce840908348622055acd7e067c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b627c7b9b9520705a558e7bf6e742bef575b6ac9fc7f18bec6f2c57d70215aa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0325d1737a51113a73ae876d344727e59ce4f399592ffe6d7141c8b5d8d8e932"
    sha256 cellar: :any_skip_relocation, sequoia:       "95df9280412ee0dfb80c7b810879d6969d5f18c8c06302239a53ab1fb5c53505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2e79b30d4f810c8416b5f99f01e883273a1395b225feb5568dc4f2c5fa546df"
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
