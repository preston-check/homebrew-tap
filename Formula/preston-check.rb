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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.48/preston-check-1.8.48.tar.gz"
  sha256 "7919aaf614aa7ef73a84f2f94482c51c4279658ec9b9000a394305438a8105b7"
  license "Apache-2.0"
  version "1.8.48"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.48"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7a13274bb177966bf65997065f4f91b0d379311fde5cd97a759b993de017c2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "070f3e09bdd769ed1c7cb69bed8da011482ae62d7ced78753f8a2bf2310889e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f578b50eae84d3e5b41a505516f656d9289aac46d1ac9fc880e9cb3613f7602"
    sha256 cellar: :any_skip_relocation, sequoia:       "05ce2ccdf80ac95d25e0aa2c085c9f25df844b17f4a440d979c319411ea163f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "302eb5eb3fe3f1043995b5c0829c0caa9a97401779f7555afb08c91fb5b8b24d"
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
