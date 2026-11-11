# The Homebrew formula for the tap Black-Rainbow-Labs/homebrew-umbra.
#
#   brew install black-rainbow-labs/umbra/umbra
#
# packaging/release.ps1 writes Formula/umbra.rb in the tap from this file, with the version and
# the sha256 values read from the release's own SHA256SUMS, so no checksum is typed by hand.
class Umbra < Formula
  desc "Small coding agent for the terminal and for editors that speak ACP"
  homepage "https://github.com/Black-Rainbow-Labs/umbra"
  version "0.7.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Black-Rainbow-Labs/umbra/releases/download/v0.7.0/umbra-aarch64-apple-darwin.tar.gz"
      sha256 "0091b48339fae11797d693e49350d53518726c5720793eefde4e6efb5a4a1d4d"
    end
    on_intel do
      url "https://github.com/Black-Rainbow-Labs/umbra/releases/download/v0.7.0/umbra-x86_64-apple-darwin.tar.gz"
      sha256 "6c4c248503ae59855e5b889185d6cca3e85143494f24c861d7d3140b058d7753"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Black-Rainbow-Labs/umbra/releases/download/v0.7.0/umbra-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c46ff5e6ccb5a17823248958cc4a4173d2bb2c220bef8f723e3cc4e78c69fc89"
    end
    on_intel do
      url "https://github.com/Black-Rainbow-Labs/umbra/releases/download/v0.7.0/umbra-x86_64-unknown-linux-musl.tar.gz"
      sha256 "c193810d9e48c9115d1f7833a763053e73d7f7957355266bbe27c09058ec2e49"
    end
  end

  head do
    url "https://github.com/Black-Rainbow-Labs/umbra.git", branch: "main"
    depends_on "rust" => :build
  end

  def install
    if build.head?
      system "cargo", "install", "--locked", "--path", ".", "--root", prefix
    else
      bin.install "umbra"
    end
    doc.install "README.md"
  end

  def caveats
    <<~CAVEATS
      Choose a model:      umbra setup
      Use it in an editor: point the editor's ACP agent at
        #{opt_bin}/umbra acp
    CAVEATS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/umbra --version")
    request = %({"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":1}})
    answer = pipe_output("#{bin}/umbra acp", "#{request}\n")
    assert_match "\"protocolVersion\":1", answer
  end
end
