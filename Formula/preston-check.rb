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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.182/preston-check-1.8.182.tar.gz"
  sha256 "f4093f98059b61835c9f941844948d650c5de02ffdc1106db2faac9f1dff2114"
  license "Apache-2.0"
  version "1.8.182"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.182"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c916d8556d041ea1656b4637ffb0383d69063522d139df9db6aeba538f1c76b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cadd6fb363c347069715346a4f756577acf1851f60ab682869eafc89a1eff5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b50bd13f783123ccc1db4b8cd19b30873d6f4f792cc200ca3b42d86048de669"
    sha256 cellar: :any_skip_relocation, sequoia:       "c65cba860636ec46ea908f9216ec52bbcbd6438a00be4a5bcc5f4c35eee25429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16b4fcc242ac2b20bda5da4599aff9fe82ec7409089646d54a29f53c75d40042"
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
