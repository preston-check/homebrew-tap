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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.86/preston-check-1.8.86.tar.gz"
  sha256 "d7f560b2181bf653009cefd2923910ecef99023d3b5958769370dead7a509228"
  license "Apache-2.0"
  version "1.8.86"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.86"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59fc02acbbf8f32218bd0e5af83defc7b85bc93bde3ff6a080fac9785a603b9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df1b136dd115519b1bcd6b26f62e2f4dfb89cfc8a962d962d35cf4acc5a799f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c55912d52022bab2ee0f3c56a81004cbe8a2e9a8c42fb035e7f3c85eba3813a3"
    sha256 cellar: :any_skip_relocation, sequoia:       "67f6bfae66cbf29c28fa71003c8a540b07f395b6015cdb9de5780ae99fdc44c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b73ddba2f6f8a5a88bf0b1e6b1a9b07eb5b7b8bc4dbc51c3465d8b328e4dec4e"
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
