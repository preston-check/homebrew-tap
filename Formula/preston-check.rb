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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.469/preston-check-1.8.469.tar.gz"
  sha256 "b374106e1d3fa9293c86bff66f5d951c29f8ad0c261ae95bdf24150265a48f4f"
  license "Apache-2.0"
  version "1.8.469"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.469"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfdc79a5ac2bdd2617972222adfe478ce97f5207517a7255beab769357e526cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "457381eb65604885ff50c2f6d704303408d441e14ed73e2de55b69c154ce4373"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff77bc922f4c56063506c76907ee3eeebae594613cb4190321cb0cf67a00393a"
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
