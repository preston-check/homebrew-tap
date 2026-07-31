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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.170/preston-check-1.8.170.tar.gz"
  sha256 "a3504860010ca72ce62470d00ce7117b1b4399a5629b03adb4401553fe694f87"
  license "Apache-2.0"
  version "1.8.170"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.170"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45b9a07f233ff194aa9823cf695ae34ea2e223ee151ad5aaddb4b2ee35d8d3ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d73c51bee3f4a4f26a9a42e77ec8138c24ea13095f87ed7a569da7908ad7d22a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9388e2a4c29ed0846726a8059a5034ea8dd056e285da9334578dce4cb906809"
    sha256 cellar: :any_skip_relocation, sequoia:       "67c8ce29b964958d183a25c1c19172951cd254d794434d8758ffe247022c8743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc4672ef15be0e8d888be486b14a2bf31d4e08ef20d62844e5c0738109b361df"
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
