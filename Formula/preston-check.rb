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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.108/preston-check-1.8.108.tar.gz"
  sha256 "200d5b8d2e58914cea09d0c7e3da6006ee267d6e4990e54aa20c132d230f4d35"
  license "Apache-2.0"
  version "1.8.108"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.108"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e90c1f2ce007fe95061c86c2bafefe650e0e21c62ab314a91d9888cc71fc6c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51c21be92793c1fbb57173be969b2d3d2041bf08fa6012567ccdc64fc7eee897"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2713c29cecbb3c59b738a5f52b2f1c0d5580e3497ca20f470bd60c2b13b741d7"
    sha256 cellar: :any_skip_relocation, sequoia:       "990ca2aa1d3e8bc84438ad432f45244b2c5020b26d4ae0fb306868a1fedaf5be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57d42994153757627f97ed1ebe9291825cc7715d76a8d8c7f22dfc4aa1d33614"
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
