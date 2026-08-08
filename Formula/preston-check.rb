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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.255/preston-check-1.8.255.tar.gz"
  sha256 "9d7b73d4f58995c7aa8276762295125791786532d3ba0761f498e4d8aa2c65cd"
  license "Apache-2.0"
  version "1.8.255"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.255"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4d61a51722eeb2cf0ff36cff0454fcb5284dd235de8af70398c428e037fe1e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "049159750edf11e9facdba5690e0282bc70cf748e1be520d93d58f18d6180e99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1655bb7da68abd93211b89b956d67e6192eaf9ae134d04967f4ed26608a2f247"
    sha256 cellar: :any_skip_relocation, sequoia:       "02d3669fb49e1c9f7b629b14b0dea26a1126691cc3662c30ff3257f42e1ae1c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1445c647d1816782051fccc89ab43efce1bf68a572afb38d68efb64e370f2c9"
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
