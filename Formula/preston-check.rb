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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.383/preston-check-1.8.383.tar.gz"
  sha256 "9a163c6e384e2d07e42d2604a9b50f5164cb25f3365c7287d6bad8fd1ea2b9b7"
  license "Apache-2.0"
  version "1.8.383"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.383"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "999932caaf9b08ae29be8adc1afdaeac869b29dec0e3adf0b68e3372b8040b56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4babcc838cdf76ea3ee63849fe684c320155d823d4176ca0682a760dc4272afb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8d1c2948cf12c18caf657740a35a9ffa1d882edf84683b5e2d59cda853466a5"
    sha256 cellar: :any_skip_relocation, sequoia:       "9686ae562264df1c7de375dd103c25bad5c615581a24a822168ac337bae1e534"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ab96124881d216acbc89527fdfbb3b3fae40183d474ae2ee9c2eeb6456370f0"
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
