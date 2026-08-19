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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.346/preston-check-1.8.346.tar.gz"
  sha256 "7e9942ec66b7f62528cee95099e7bb7eb2eedd5bc7f3aecf09b5f0f36a8a4664"
  license "Apache-2.0"
  version "1.8.346"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.346"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fb43559c53d2d5a8a41e3f9bd84781a68fe297b543735b5ce72153c45c46b21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58d29bd4de694b61e8098201d4f736666b4688b63ce7901c934d8f0d559a3b5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "405993a9d6a8eb48f80a81da01bf547e45858f26c57ecd819a3e62f141d7f293"
    sha256 cellar: :any_skip_relocation, sequoia:       "00af451b94d2da69d1f3a531e46421fd25106ee37048f9aee70f3f11faffc9bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b87014cf976ebff5b31032db7c5bc5474fd054c1396bc110cee740f5a91d2d80"
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
