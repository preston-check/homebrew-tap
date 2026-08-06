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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.229/preston-check-1.8.229.tar.gz"
  sha256 "3c0d6f67f91448a7d3853a61e7864967f8d6a7a4c5e54735ac07c58ce11c223a"
  license "Apache-2.0"
  version "1.8.229"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.229"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "720ff7941ac54a95670e7948ba6a7038ed16fd23111725eef6ad8e31893ef9d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e44fe0d09087595e3b61d73c248dfb9581ebf49d050f595f42217ae6e4363c39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "423904fe6ad3323eca62e5cb1a026ef0afe7de2bbb5312ab5e97295e320867d4"
    sha256 cellar: :any_skip_relocation, sequoia:       "f33d428eb8e2930c34392da054d0cf2ccef4166a0061cd9b17a16e91b7e1a94f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff9aa79254d9f539706d5d2b5517dcff4a67a67e69097251261ef3e4982a39c2"
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
