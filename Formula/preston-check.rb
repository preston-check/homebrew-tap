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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.153/preston-check-1.8.153.tar.gz"
  sha256 "4851d9d77d4947d32f3e2461d83f9c17672408850f955a5645714f9f371b8718"
  license "Apache-2.0"
  version "1.8.153"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.153"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f33f2ca19b9396910acd78ed71f0d4380331e3591dfd306aa7a7585ae056f4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28bd891c3f2ff739a43adfd8c93d2bc849155c5ad2f07f54dea404706434d35f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5fb678eb55f375522b822e7ce45b9d3a705b83ca311c5143929553e0c471bc6"
    sha256 cellar: :any_skip_relocation, sequoia:       "653bbc8dc4223d20bfb092f378e9c818f40a1be3639d81909a11d4dfac6a57a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b34f90ace6f4c45081ed30e14faab3c768f5b77de79ef76f3a1f0ccc950365ee"
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
