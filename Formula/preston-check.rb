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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.352/preston-check-1.8.352.tar.gz"
  sha256 "cb50a4af1ba6b64fcca65bf3f990389bd913004c13391fa4e80d1ee90f06adb7"
  license "Apache-2.0"
  version "1.8.352"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.352"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3babc5fbc0955ae2e07eb41c6bb6b91c02ab0598ef8e52dd19b435eb76205a83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51ceb9d2ad4937bb97dd5144cbe3fb5097507eceb83e7834653f2cf7426ba059"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5db4f46386f76623568827e7616c23097cd705f964c8675596bbe574e945ccac"
    sha256 cellar: :any_skip_relocation, sequoia:       "4ce57dd8fe4d3c8f017acc3486494dcea5469b76422f159a58863e30451bfa23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40655190c215cd8b1d93b1b1238d53cf0b01e8d588e547744c619799e47b12ea"
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
