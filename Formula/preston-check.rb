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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.198/preston-check-1.8.198.tar.gz"
  sha256 "0ee9073bcabe8a54bc47c1174fec3aa890038a428da18b19c3f30bc9cde6ec6f"
  license "Apache-2.0"
  version "1.8.198"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.198"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fe18e7c5be7d51db4c3056307ff8eec949501bbcf98859fc49580d129aa7646"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f4d4fc9d9a3981bef1280972f622866f055e70c6cc2ffb2df228ef5edeb2753"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eef3f76f113eec470163ca8843be5bb306cac575d22a8a1982f8c71896f5ff4e"
    sha256 cellar: :any_skip_relocation, sequoia:       "95a09b4c791e92a66bef80986ea194d90a420080ca7fed0557df20ddbc1f8cdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "395a5f94b6db694f56ac3e38abedf49db5d21154c49810a5fc255e0a4ab61223"
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
