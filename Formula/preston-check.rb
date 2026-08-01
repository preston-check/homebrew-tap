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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.175/preston-check-1.8.175.tar.gz"
  sha256 "e52029418a951f55766cb61c75555a4c0fde8fdff4b46d5def0fd067a905a012"
  license "Apache-2.0"
  version "1.8.175"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.175"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c00ca2ec0f053989981df58c6e008bac7b91d2c0f66d8cc34f15ae705006a553"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d75614aa8520d88741f26ece59b3ded8a61bf9d48845723d392df4373750259c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbff506e899f2ad5e994f21ba99b57034ff2d76d77349c017c5aaadfb70181c0"
    sha256 cellar: :any_skip_relocation, sequoia:       "c1836cc583f6c8e725f881900c173ecd8cf862800def9295a596846b6173c4f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f546bec72af4567e3ec191d4f356eb8086560f6c20911ba2f6105fa83b0d77b"
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
