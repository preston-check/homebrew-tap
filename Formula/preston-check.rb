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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.431/preston-check-1.8.431.tar.gz"
  sha256 "ebb5c7f794441b6d880b5bd9f73afc31542056a20514c6dc9e634bc046995ebf"
  license "Apache-2.0"
  version "1.8.431"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.431"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ff227969f8eba9ed854c3d60892038b3d85e985f66d30efbc8bb5afe2e66491"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e838428abb94456bd6b51f29b5d1d66bd766709cc64514f50fff9eb5c447633"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cef9493277e492c9f71782e7006d4074897f462fab38fe2b4672524e132f1ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2956f6c3b5b60ab2be417b7268e036b9a4d3ea7923a9c009b7e511afddeead3"
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
