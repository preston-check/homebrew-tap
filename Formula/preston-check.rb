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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.3/preston-check-1.8.3.tar.gz"
  sha256 "668fda123a71393b5e97b264d14caf9dbe559b86c36ca13f4e1a2a95bed1ca79"
  license "Apache-2.0"
  version "1.8.3"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d61f581a61b0f9af31396a0a3944c7fb4db27887b184d58c4f0663d04c8ba615"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa13fe378c47a79b6bb3df9049b656e5c6de3a85fd958a8f0421c637919514a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f607704e6629c55d724e00586a7fc031b10e5cf470859966101611e05fa38160"
    sha256 cellar: :any_skip_relocation, sequoia:       "42731acb169267887b499576344c08a5b4072b97ac5f30c80943ed1c8ea1aea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5268a4485e0e081a529e955981d1ca3988406f1f12d7ee32fc694c7ad51902c0"
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
