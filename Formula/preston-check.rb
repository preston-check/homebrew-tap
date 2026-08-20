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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.353/preston-check-1.8.353.tar.gz"
  sha256 "808d6be0afb58607a4b0a0ca60df31a238b1865c6caa7ea5549883d09452b607"
  license "Apache-2.0"
  version "1.8.353"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.353"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5963359657aa5b60823be4747940ba88f7efb62e8d0cb1b23cd4a978e0c28ecc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2eda4644dde6773eea013ca3c532e32fae1f9d909eaaa47f6dbca55a526b041"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8e09da4867fdb4deb2079bb841dc5e979960e3aee9f215ae280c0d59187360e"
    sha256 cellar: :any_skip_relocation, sequoia:       "a3b79e00bc294dff280c185071d464dfbc47e28a14f87bf3f921e4eefe80bcd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8667b520a089b41fe5942c526a29b843fa9599caa23dba66d44aeaa6047d16a"
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
