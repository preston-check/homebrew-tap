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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.247/preston-check-1.8.247.tar.gz"
  sha256 "652ea4ee72675d4e294c9aee4efb5fd87848d577ce43eecf304b1d2923bb8922"
  license "Apache-2.0"
  version "1.8.247"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.247"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65cab43a2497502b59f567e4b83402349d158c947d380684575bf0d95883116c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d1d5cb2eca429d5e004aec27f5f5e50e8a94a312bfdacd3190bfd89d7d7574f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a45497a5d0304622255570b1f764597d939e776f5aecb6698e60bb2a6c5f50fa"
    sha256 cellar: :any_skip_relocation, sequoia:       "b9bdce31eae20e5e808892516192e1941a2b3c12b1a49e9416684f45af53aea3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96a4daaaa9e4022a5bc3233f41ef3ae8bcfd09d8b762aafcba3301d9d34ad716"
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
