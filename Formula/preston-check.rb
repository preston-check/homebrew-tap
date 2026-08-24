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
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.379/preston-check-1.8.379.tar.gz"
  sha256 "dd578a3256b0159bd5be157f7e5b863f250bd3342fa6e0bacbd7d04d9b484e82"
  license "Apache-2.0"
  version "1.8.379"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.379"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d72d8188a3015806f91037bbeb8e56c0cb77e9579a0583eb015879afe15e524"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ad43af66569e2695da7dab411b2cb22d54861e7a8ef7ec896dd91db42966cf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5703296984607d80cdcd6728ba27ccb22de1995030ec41aa5469614f002653cb"
    sha256 cellar: :any_skip_relocation, sequoia:       "fc57b769f9e1019cb94c6d00c5d2f92f1dd25bbf5078ede3c5df9be3b22a73ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "613dfe32a3c143e6f4a72d7589d0f61995a6cad703bd5c54aa4e05d58325699d"
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
