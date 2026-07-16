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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.23/preston-check-1.8.23.tar.gz"
  sha256 "e65df1eefd77b965319843b526d877cab55ae5909a68080e09b3bb1522e2c2e7"
  license "Apache-2.0"
  version "1.8.23"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.23"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efb33cb8090e6c0312cc73bee4058748a6e31bff9378806945a1b97c2dbd56e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bb574fe106b81f3f57705c5cd758c9ceba9f0ebfe83bbc3d4036ff50c199b99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "003101bb7de3f79157cda36914236fb514eaf3ce2a43c6353fb3b94026c87944"
    sha256 cellar: :any_skip_relocation, sequoia:       "dd58075966c1d3acde069f2df2227204edfeb1b1257c4458bfbf06395e2c91cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33e50fd9126c686d33aedb4f479f63b0cb9504b4ccfc36f44896347de270e80b"
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
