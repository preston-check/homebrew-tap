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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.307/preston-check-1.8.307.tar.gz"
  sha256 "48664313c1203abe08bb796f3e90629ec330773cd7efd95e9979692db23dcdeb"
  license "Apache-2.0"
  version "1.8.307"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.307"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1045ef7978f2390c5e8488fc27185f443d9bb0f457fc6c73244095bb5bb89c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d31fc5835cd76e9b9be58be4f5e2c02fe4f02ef7b792d1ba134a080b11de9b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7a1cb6aa21777f7e4e250263c756dd11cf4a1378c92afff86b62faac38f68fa"
    sha256 cellar: :any_skip_relocation, sequoia:       "b8bb1d5b3ef70b98eb47bec082ee1311117340f901a6fd106660c2710f28101b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cd9f6aa3adece4337ce37ec6972dbc89e6a412e813ec83447d57b8b891bc919"
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
