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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.90/preston-check-1.8.90.tar.gz"
  sha256 "90b23780ca682133195751810cf5003ceb20f66c6fe7136dcec18b9303b623c2"
  license "Apache-2.0"
  version "1.8.90"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.90"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87fb9e039efd01e5d4203c19bac697bc3e284f7658f4c197401d677c13456f7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fb6fd42f312be01f00f1689a02dc189a4be59008852251ab48c201f80c58fc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "462a3fa200adabfe84ec30f0c070a4616a4bacbc1c60e790900fa84e96b00239"
    sha256 cellar: :any_skip_relocation, sequoia:       "8873434ae135e8de35acba7ebc40250f446501ffc327fb90c608e7f6ebbb1828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f673b77190fbdd0e24d6b0ba4fed14635d40c94e6758a13f1964ae3a477a421"
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
