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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.544/preston-check-1.8.544.tar.gz"
  sha256 "07ad28e2401341d061bd979b8425c4cc290a5177e1d48eda2a3c53dc1423e118"
  license "Apache-2.0"
  version "1.8.544"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.544"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "903175be220c6c050f43e4e4e6aa5e878c1dff45dfb52ca4ec0d03dddb061d9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7e194ac7819525de320578c01910bf72c5741324075b9a569e99863f17eebb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "050332c9bd3383ad95e22dfd03b3579382e708b281d37d80a0a34af7904b42b4"
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
