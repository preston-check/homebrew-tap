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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.91/preston-check-1.8.91.tar.gz"
  sha256 "837121cf5904a27d52ee0f475e4227fba76483ad6268d8be33cecfe70cece361"
  license "Apache-2.0"
  version "1.8.91"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.91"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c49bedf36fdf0d7008b6578e3a05f717b862d41ca0e5a9bb7401932e7fc9a43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f1b3165582bd8408f1d3d2c97e0183a5ac85e92164efc345598eeccd0f6874e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "731bfd9c243911e1324720711763d30b5bf116187e726f4c1f9dd7bad68e87e0"
    sha256 cellar: :any_skip_relocation, sequoia:       "3efba42cab0234f1c2b1fb90bab10d3b931fc4c34b80bd0a0c3aa6589c787893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5811341a14ba9b10091547a11e3baee92624ff71e2e53af7083aba81e461df14"
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
