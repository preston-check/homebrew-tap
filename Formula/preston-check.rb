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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.327/preston-check-1.8.327.tar.gz"
  sha256 "0be1add796a8dafb80ea3452dbbec403d8b020a7b666b3aae0629b03f392a52d"
  license "Apache-2.0"
  version "1.8.327"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.327"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da26a02f3fea5bc97147194ecd1961dc3d5d216df0be5532242c1544e0acb73c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0122a85d33935a4c464313e1bab2191c6dfb4b5d0aacf35a10f76402f860223d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa9bb18ac3a7ddaa910a986eacc3721b48fc6a01ce782da52757eb60c006f871"
    sha256 cellar: :any_skip_relocation, sequoia:       "e31b3560beeac1fd1385914e1d6d4a7c4a0fa60495e126b8de19392ada76be2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5b1e5d01ad5728558530bcd9fc51a3fd25e8f4b468fe22046a1ba549893feaa"
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
