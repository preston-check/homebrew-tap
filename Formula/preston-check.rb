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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.271/preston-check-1.8.271.tar.gz"
  sha256 "39fa8108c87a7e73c18cf6a6ebbf0b7fe5ebc1dfd10e1a54a704d1e140e87ece"
  license "Apache-2.0"
  version "1.8.271"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.271"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a0881e54e85e8012c1cd7f404eef7aab3136e8949d3b741021f9a948c00558c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7477feaf75f7780c6893b09670a201405bbb75e694f6d86d1a45626bd78fcaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02408f38d8fb1bf3cfc9b17bb63f229386af6640439df57973f5f1c444c8800f"
    sha256 cellar: :any_skip_relocation, sequoia:       "c0a788c0e33abaf7ca97e36a7666fcd615d5a2c339cc780c082318b576a01937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3575d373d8ff20f3146f3a4b7c841883047c6741b87e98edbc76597fcee37b30"
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
