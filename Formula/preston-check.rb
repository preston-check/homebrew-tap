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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.106/preston-check-1.8.106.tar.gz"
  sha256 "b185d916295447ee682d111fade914b9fb79aaa01d89bfe0b30a21f2ae3bb94d"
  license "Apache-2.0"
  version "1.8.106"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.106"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a74c4b936ed5bb5591ef6a74f843a784cb0ccdd046b2a83e8061faacefc81463"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ed762137a426ac831a4deffe3adf22d114619cc02ae6c5cbb597cd2105e7604"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "543e42ac2b06f8dd0e2018c7eca327704d8ae5e5a4628d6968bedda22915e911"
    sha256 cellar: :any_skip_relocation, sequoia:       "f0d3ebf3c056e35fad0355a94b6fed9ebd7b38ab68045cce06a79a010587932f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd5fecca2230a387416cb27ac24491932041ad610d2c63d4e401d65083e06108"
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
