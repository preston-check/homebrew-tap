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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.205/preston-check-1.8.205.tar.gz"
  sha256 "01bd1d6415b5244a9885dca2a4656a400d61df4775acf46f8b25eef957c5f3e5"
  license "Apache-2.0"
  version "1.8.205"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.205"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3302c9ebc7bca6ce08d258dd31645e454e234f48aa2e5e8f1018a51309ba401"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29eb4dc100c1f50425548aafac6d619fde62c697f307cd84ebc1120818e4111d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a942d2d9bfea43f97d106cf517128d40fbafbeccb24c30f32c967b5bfe53e8b7"
    sha256 cellar: :any_skip_relocation, sequoia:       "2c44cb8cfa963ad34fc4fcd11944bf2f8f647ab239c062e46d506dabd8d5c85e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19a75718f8336c9117adc57efa8fdfd357bdb448185ca8fe0a79468cf45494e6"
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
