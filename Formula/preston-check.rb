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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.191/preston-check-1.8.191.tar.gz"
  sha256 "4ccbd53592f017a69792212a4612a22867f9298182d3a84646cec7c79b185554"
  license "Apache-2.0"
  version "1.8.191"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.191"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1f5ec4aef70b83fb19fc52ebf31fd3a7a351fc5eebffc70b46462c13075c091"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e0ad57e0314d6d61341647b817b99ef6e186eca55e6e43d610e901f1d83ce3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b7dfe40ce94798b9a77027a5526be733543fb0d60bf3d8deb06b0ae311599d9"
    sha256 cellar: :any_skip_relocation, sequoia:       "05ff80e851886fa4a60674531c18a9cd86b9c3fb9be95d5ae705e2222a588343"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b0c468411c309738c96832786c38d6acd7d3b3937b1ca798138bbfc21d4c438"
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
