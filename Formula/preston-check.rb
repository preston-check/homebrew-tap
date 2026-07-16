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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.21/preston-check-1.8.21.tar.gz"
  sha256 "c1c15dca65ab8f8aadc384b0ca0c8be5acc15a7ce86c0aa7916d18f0d3526823"
  license "Apache-2.0"
  version "1.8.21"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.21"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88b674304f025e7ecbf1109f3bd32dcc50d5b9f4dfbe0d9e4c8e802a5c0876a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7ec5f3f2998a37db6f24a1b3aa1d61a18d2957178796bce0299c65eac989bd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ba1fbd5db9b0e7940fd5fe4802be5e0ea33ccd43ec143c7cc2e5b841284075d"
    sha256 cellar: :any_skip_relocation, sequoia:       "606f32db178601c8a3361ef718c83dce0e275f25dfebfb5eef56b1887696f8e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95ce24622f3e520806b80b834bbd771cced31e57dc546b42e1b3bab12e3be546"
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
