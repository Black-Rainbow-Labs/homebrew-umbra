# The Homebrew formula for the tap Black-Rainbow-Labs/homebrew-umbra.
#
#   brew install black-rainbow-labs/umbra/umbra
#
# packaging/release.ps1 writes Formula/umbra.rb in the tap from this file, with the version and
# the sha256 values read from the release's own SHA256SUMS, so no checksum is typed by hand.
class Umbra < Formula
  desc "Small coding agent for the terminal and for editors that speak ACP"
  homepage "https://github.com/Black-Rainbow-Labs/umbra"
  version "0.4.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Black-Rainbow-Labs/umbra/releases/download/v0.4.1/umbra-aarch64-apple-darwin.tar.gz"
      sha256 "9bb935f3e478eca57e3bbc6e8918060110bc09c019bec25d91ab11cb53715baa"
    end
    on_intel do
      url "https://github.com/Black-Rainbow-Labs/umbra/releases/download/v0.4.1/umbra-x86_64-apple-darwin.tar.gz"
      sha256 "d1dd98676825668332e0b7adcf93ff152e0b35e03f8742afb564d941b524d56f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Black-Rainbow-Labs/umbra/releases/download/v0.4.1/umbra-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9d025e1f56df42f90023954522d4106c82cae8e078df306b288776817b16ee31"
    end
    on_intel do
      url "https://github.com/Black-Rainbow-Labs/umbra/releases/download/v0.4.1/umbra-x86_64-unknown-linux-musl.tar.gz"
      sha256 "b5b22a3a26bfae35f233bf93aad0af6a2902a263021babca9b830cfa23b714b5"
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
