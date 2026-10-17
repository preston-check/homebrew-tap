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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.557/preston-check-1.8.557.tar.gz"
  sha256 "096919589415a87f1cd2b00481652663073213d46734fda2c4fc196297bbc3f8"
  license "Apache-2.0"
  version "1.8.557"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.557"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10afdfedfe294b45b4fa172b2bc40fcaa6300b483d056e2a585eb3f0758750f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa1a7818df4b2cd58dc2043f09cd4f6c4666abd1705b26294be1ee697f1b6ff7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56747bd3426db429c813136bcce389dc8665450aedd9173bdc31b8343a796b59"
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
