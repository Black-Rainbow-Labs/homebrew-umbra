# The Homebrew formula for the tap Black-Rainbow-Labs/homebrew-umbra.
#
#   brew install black-rainbow-labs/umbra/umbra
#
# packaging/release.ps1 writes Formula/umbra.rb in the tap from this file, with the version and
# the sha256 values read from the release's own SHA256SUMS, so no checksum is typed by hand.
class Umbra < Formula
  desc "Small coding agent for the terminal and for editors that speak ACP"
  homepage "https://github.com/Black-Rainbow-Labs/umbra"
  version "0.5.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Black-Rainbow-Labs/umbra/releases/download/v0.5.0/umbra-aarch64-apple-darwin.tar.gz"
      sha256 "ade5483c03c375272ad41db8962bcbc1e945fb5b7beb13d9ee7c856ec37c9614"
    end
    on_intel do
      url "https://github.com/Black-Rainbow-Labs/umbra/releases/download/v0.5.0/umbra-x86_64-apple-darwin.tar.gz"
      sha256 "e69811300717165744106990ddc5ab82754ade220096e3c1a9bbbeaac7484e01"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Black-Rainbow-Labs/umbra/releases/download/v0.5.0/umbra-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f206a1ecaf7b518aab671df5d04e222e7463417f24aed16ac3a0b31b350f032e"
    end
    on_intel do
      url "https://github.com/Black-Rainbow-Labs/umbra/releases/download/v0.5.0/umbra-x86_64-unknown-linux-musl.tar.gz"
      sha256 "55614c9180b7a2704a11f8a09a77802010e6506c34235fd83d646ade479684eb"
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
