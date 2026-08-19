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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.342/preston-check-1.8.342.tar.gz"
  sha256 "69ce2771f3e56a23bae2eca6ef23c597a6b8c89a3f7869c7761f93fb326c8df4"
  license "Apache-2.0"
  version "1.8.342"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.342"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d26e56850676357d28c73f5e3d21dd402e3cd05387c6d1e522276c3ebe3cef3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37fefa0922cb37bf7deda67e6b8dfcf8f6420cafa3d04e6927fa97dc278fdf32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19f150b37eaab02b5428fe0106696b8017ff663b230c98eff4d420645e9a1a8a"
    sha256 cellar: :any_skip_relocation, sequoia:       "1a4ab33aa5af4bcc4a182cc3887d6a1a7541fdd7134389dd2ae2016d3f867b93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1992738913330033004b5c06a99ebcf25e3bf6149d4adaaf1e885ab365d3968c"
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
