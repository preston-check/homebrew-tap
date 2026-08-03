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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.203/preston-check-1.8.203.tar.gz"
  sha256 "594e87cdee34572d2c76058c819cdc11439506933a59d591128c9bc30c9b6495"
  license "Apache-2.0"
  version "1.8.203"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.203"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46b77c42611fa5c95b3b2efe086c2639f9c68fe8289ac889344ea44f9e67eca3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38d351031f2938a0733a069e50146c48bcef0ab2dbfc119d3592893407d67db8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38fac1d969da4e1b3f662387d493e5ec138965c04aa2bd8485c00f52d619c6fc"
    sha256 cellar: :any_skip_relocation, sequoia:       "7e794370d04c8f76a8a1ab78b335c87b231107c421e200d24f4a3dc7427b6338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc0b498382239544e040b0423295f1d25925d48845c42eacc93b211a53d3c879"
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
