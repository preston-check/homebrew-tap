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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.39/preston-check-1.8.39.tar.gz"
  sha256 "687c31db3e81d9a8f59d45a30ec7d8d7706a8a6f2cbee3be424f036f48d90b30"
  license "Apache-2.0"
  version "1.8.39"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.39"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce5bcd2886ddc9fe625d0e518fe386fcdda5ce2cae76ca97574b6ae3931fe202"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7236fbb3623cd5819631c67759035c24742ff03b170cdee2ce736996f1d87a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20cd47956f67271289ab0b2685d5b28674728729b1fd2b06ee755dafa30e6ad7"
    sha256 cellar: :any_skip_relocation, sequoia:       "5e1763349750d35919859c6a2f4a6e120119743d054a31ea74ba3ed2974b0c02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39fe62d5aac5bdc9109a1fa52420bfcbdefcfc88658ab5488939029decbfa439"
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
