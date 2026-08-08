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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.278/preston-check-1.8.278.tar.gz"
  sha256 "84b88dbf90cf537644b74198ac23d575a18fbde11f26bf2cb2fdc213d583e5b1"
  license "Apache-2.0"
  version "1.8.278"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.278"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "745d9e3705a189a32679c579c08f7d26870f35697c0084489ee871623f849181"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "624d007a4085f18e72b4828ef378f8fefa977e4cd450acd7adf2801c8b13674f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c4d0c886a1e4660090dff89a45913ba8dd26af201806d9c12d8eac8b1e5eccd"
    sha256 cellar: :any_skip_relocation, sequoia:       "7850ffd436381657f41f57036b810cd5a71380e6877b17b6c296fb0d52dff2a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "588181c9be420b6caf0b715f992661a57ae687a48c029a6933925f68ed3999e3"
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
