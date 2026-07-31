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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.169/preston-check-1.8.169.tar.gz"
  sha256 "f43d3d5f2098e697f868ac98a030bdcdf342a092f649089d949c4fed43c1a5fe"
  license "Apache-2.0"
  version "1.8.169"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.169"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "105177a8f9d333a9ed1f6152f71a62d01b7b389f4c8b062463241af486634b8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb85ca61cf9b648ed0a27ed516c1b39f4f562b29d1bd0d8fd6fa6a25177e565f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "933df55d9b99c9c7be4b3d0266d2019b0c16c807317cd3a4aee52710fe52d81c"
    sha256 cellar: :any_skip_relocation, sequoia:       "b7d52cc754bacd70a9547ad2cecda5ab53fc76ef979333d66241bbfa1cc64ebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19ca6ccda60643a6b34bf0c1744a5102df7897c2a89a92b3a01cf2f13121e7ae"
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
