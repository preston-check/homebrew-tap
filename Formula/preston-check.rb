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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.16/preston-check-1.8.16.tar.gz"
  sha256 "249eb98d42118670354e3ff8ecc612fd074b809b45ec478141e3b53c152272af"
  license "Apache-2.0"
  version "1.8.16"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.16"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9e34090beb79fa250881ff5266dc182ab0c7b082050da80b0e5e6882df33450"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f66dd1e787502c572ba55507d5b54c3e550f038347ddc4ac11b8479cd364bf6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "880eedad80b31b06935d98b7aa41f1dad582c39250ff829ebc06176885ddf861"
    sha256 cellar: :any_skip_relocation, sequoia:       "e145a3fa952de3a85eec1c2b7606b2d1b8c6e2b39f44c73bdff00d179efcbe5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dcd66fee29924ac7e8ff4e8a6f56073c1185a9b656d6ecb7f6407f0d28a6002"
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
