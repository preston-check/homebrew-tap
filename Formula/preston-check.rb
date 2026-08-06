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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.230/preston-check-1.8.230.tar.gz"
  sha256 "80f91a4792a7b17debdfd205f3f230d17a7a213c8594fc93e6311f6e9114c3fb"
  license "Apache-2.0"
  version "1.8.230"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.230"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05e761c68f9609e1ee7e72c7e02355a92bbed7e40129722c1959a7e0cab0b926"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7638289055dc1b243de3483250ca08048aed3a0fe94070ee0440f6fc1c35ffb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c59d7015b2d611584b7c2e167133dec02955ab87e6a679e82df32d7e945a0373"
    sha256 cellar: :any_skip_relocation, sequoia:       "a00a1d173aa913f3b42555d2151e6c768c9a629044b0be2f2e378925ba6da7d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "638eb0adc56dfca4e7229d8185d8ec39ce9023d5bb466a23939ea9d86990e954"
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
