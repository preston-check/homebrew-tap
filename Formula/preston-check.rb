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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.366/preston-check-1.8.366.tar.gz"
  sha256 "1228a790339754904d69e7c780a14cd8ff82a473a71787f6c1d60bd9f9ddd893"
  license "Apache-2.0"
  version "1.8.366"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.366"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55651e0d8d26a4d274576c7d7351d40a152ac46f978ace7d7e322dd5f2e1a003"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "185b8ea788eca25a2ba5a9220d8e9ce559c74926cbb8885311941841e9416dd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dfe3d5ce260d8f43b6f86f2506ec3c2c81ac77c2e0c3f2bb0f98d1cac0714c0"
    sha256 cellar: :any_skip_relocation, sequoia:       "df37da35eba3ebb944180a2f130b18abd689447a676c1e966732b4e38095c598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79f1b778d2532b74005a526e33c5e77beb84a3a2605e33b4dadbeb39273f5df9"
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
