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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.195/preston-check-1.8.195.tar.gz"
  sha256 "f4ce679d23d703c7661de6393dd622d809fca3d8dfe270d14f784a49cc13f0a5"
  license "Apache-2.0"
  version "1.8.195"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.195"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c54d942a340ef7ead0ce895149bef0d6ca17780acc1c14c747b4d7a28775cd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64b6a13482c3d163dca653949f1fb64b380cfcb32627ce8b5d49df324bf4debe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6587767dd5549b640f2a5634654aea24f8f69085c443a08f63bf49270ebe7c5"
    sha256 cellar: :any_skip_relocation, sequoia:       "11fdc16a13e506f4b616f82a21379fecc03266f02d8fc8ed08dd1a7a0672d7dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4cd7bdb7a3b6bc34d72694a90d770c380c69f2ace45257831bffd8e66da8063"
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
