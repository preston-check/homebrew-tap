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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.184/preston-check-1.8.184.tar.gz"
  sha256 "30b992314d9a398c15256df291a75b3e6cb8eab784a980689d3503a9b96d3604"
  license "Apache-2.0"
  version "1.8.184"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.184"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fd04e6cb25b3bcdb826fcad5f77cf2f3bc84d35b6ba62e47205ab620729410b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38635d9ee23b9ef9b2b05538ebfe9ec8af9bcf88df71e7853abb8ce7ec23b107"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d36eae724b7cb31a3e655cccc00c01551832159f351657776401849ec6cc3bb"
    sha256 cellar: :any_skip_relocation, sequoia:       "639d89414118d5089909cae2fbd31ccc717a01b684480e940ad588af7c4b6651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11ac4d4aa5bd4f57a4d06f764ae75efbbcfd8a632347ad13c7858c2ae187f4a8"
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
