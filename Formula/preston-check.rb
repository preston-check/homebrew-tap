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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.174/preston-check-1.8.174.tar.gz"
  sha256 "092630c3fc18ee680f96575b01eea216e99b0c3b0ebefae4e66a95b8eb07a3c0"
  license "Apache-2.0"
  version "1.8.174"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.174"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c5bca71ac53ca4f95da72a6804d646d6231a77c680888aeb5e32867f4bbc978"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0b5821e4e2f9fe75d421a5a43a5ab5c56ed794ccd08312c9f93ea01137fb467"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa0ecb6189ec479ed17cc8ecbf9a77dd1ca65366d95e36882ed8f4da6a4dc805"
    sha256 cellar: :any_skip_relocation, sequoia:       "f68cd29ef10bb731789d861602b40e020464142905b91e5103fc276cb4a5c936"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd4781552d8f1b10db44d0a0326e516de755ce1ae0c1569a075e1941dac3c8f2"
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
