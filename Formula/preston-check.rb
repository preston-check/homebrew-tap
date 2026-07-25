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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.98/preston-check-1.8.98.tar.gz"
  sha256 "ce8b08b0b64dbb5e21a41675f4469d736da529c05392d9ebeb928abfee1a64c6"
  license "Apache-2.0"
  version "1.8.98"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.98"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b16921890be120444fe37db5178e72d5d1ea4786f468be34aff7a95eda977edc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27d8f4b1043ea335b9be6825a22953b3f6698bbfdd925a13064ab59af4418268"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "053d66c6771e01e22032863002a718128a066f3191b1c814be52359fc968a5f9"
    sha256 cellar: :any_skip_relocation, sequoia:       "d5ab614801a992a2f9693a9a6ada25802671d49fa8dc2a474a236fcefdf618bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5ea8a1bcbcc3aaf809a09b1bb6fd47f667d636a2eb1da20e456c52cfdfe16f8"
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
