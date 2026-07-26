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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.119/preston-check-1.8.119.tar.gz"
  sha256 "f65e548112680ac066b9f1f0aac5dae1aa65e395eccea6c1f1112c298a0e0692"
  license "Apache-2.0"
  version "1.8.119"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.119"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe0678e9162012119d6d0187333a14a0e985bf5d4f1e1c49af10570888e49ba3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9673bed5932861b7543b8f432ddbb850e81b8cec080d03198a78b2046bb8029"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65c41aa37c1c460f775d2da78d2af8ee20d180ab2b12d812b23a4eff0bb735a5"
    sha256 cellar: :any_skip_relocation, sequoia:       "9ce6f8aae2fcc4ad6a83627dcbc97481cdfb199ca283214105a92cc5122b9835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a501a32dc6fa242efc80064b2f10d19645e83178fa30d21300dae9d1d281e0f"
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
