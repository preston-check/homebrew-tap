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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.145/preston-check-1.8.145.tar.gz"
  sha256 "794baf31ae24f36b7f3557162287707aedfad694c758d13fbfca18d4661eae55"
  license "Apache-2.0"
  version "1.8.145"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.145"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03da0f7cab36c3bacee3151fa06ff4335b2c10a05c203dcf03128e4fb0ec89a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72dc0bfd8c8ad679ac69f7fe68c94495d7a42b693f8a43b1157a1e37167ce274"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3f5b37f2a54f24b115dbaffd3ae71894d6bd147c2be5ca61675862f0961018a"
    sha256 cellar: :any_skip_relocation, sequoia:       "e89a40d85a22b5da61ab0ddfb689bf3bd878cd16846148c7550429055bd01e58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42135114717aaca26b5857a009c97f03304816e6ce3a551aba0aae5357342beb"
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
