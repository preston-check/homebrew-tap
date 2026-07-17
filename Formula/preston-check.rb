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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.44/preston-check-1.8.44.tar.gz"
  sha256 "7ff62507eb736a9f909b7979a33516b47cb8eb8dae3ac3e08bac3d052af30073"
  license "Apache-2.0"
  version "1.8.44"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.44"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9dc00378c91a19d8568cfd2e7d8688bf6b36cf4584ce09696bb7e06b2f608bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c6a5bccd7604690ac5d1bf4794465fc2a6adb1e6848880fb9c3a2167c5e7836"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23a744fc86cc8669d0b6f082644597429c0e7a1a534947a23c6e957fcedf27e6"
    sha256 cellar: :any_skip_relocation, sequoia:       "26ae8e05cc8b211ba78f80b1b84ecf9eb9c6efe30272a785b99e2b19153b7bc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce032dce538337f7984ab40053cfae2fcd43fcc3974d6f093703d82111a9b2b6"
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
