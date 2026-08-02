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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.190/preston-check-1.8.190.tar.gz"
  sha256 "25544b257a503f450673cad66d824145a4b239d392e0568fd6222e1c4debd58f"
  license "Apache-2.0"
  version "1.8.190"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.190"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92bf57cdf91e336818a6343925355f1856473b881e113606cadf55647f31093c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5803c59f4341ff0497bbe4de5f8e6476a96d98224b3f6965cdfba5c8bd80afe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30609e6c45d5f1bb5e4be8abc0ff670f573594201b4482349fd9a5ca9b77bf0d"
    sha256 cellar: :any_skip_relocation, sequoia:       "88a36010ac5bff3e80829a0626088aa91025ef1ab658771237d53af5cb2d5330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2aa3758fd869335a4529159ae9a57f182369c3d74e4adefeb7dbe2117b5eafb9"
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
