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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.129/preston-check-1.8.129.tar.gz"
  sha256 "83890dcad91b3e44b389cff69d898692903133f566cbeedda0d9c6ef0c369542"
  license "Apache-2.0"
  version "1.8.129"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.129"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd893a5a69a8933462a959e9c56b0796ea36788254cd38a577584553a07efa6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "054dd304c00e9234059ac44ab509bbfec254a3d9bc13914a00708251da576cd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51bcaf9de5854b78a889e7f25ffeba8db34371bede60cc6e79fd9fc7d9d20797"
    sha256 cellar: :any_skip_relocation, sequoia:       "aa1f0023f414ce909c9ae1349e7107360bda24993427b96660c6bfe33967a7df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "440424ec9ecf7d164355f8fc7633f86649b8d325f3a94fd39e5559b461b7a318"
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
