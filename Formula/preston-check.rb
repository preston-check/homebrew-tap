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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.319/preston-check-1.8.319.tar.gz"
  sha256 "2a03c74ef8b5d14845ab93fb252a0094b06b93abf37b164e995c98114e6e9142"
  license "Apache-2.0"
  version "1.8.319"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.319"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efd7ccc5a92f50011159ec227e7c955936d43708090aa549557eb6f11d4d5839"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea47ad0fe1c6a513100771200712c1127c3d0e23d7e94eba10abcaffea0efaee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ebe3450c3bfa2257b82f3f954e365c1f0305ace1673bc88f2598f8d3d860c14"
    sha256 cellar: :any_skip_relocation, sequoia:       "1ca7131af64a65efd03346648c9f7c9d6aa7dba9f908612e42d7851d88e3abc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60bc5ac7286bebb674ebe4ce7c9668c10b1cbabe35c0a52cc225803707007171"
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
