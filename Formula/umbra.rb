# The Homebrew formula for the tap Black-Rainbow-Labs/homebrew-umbra.
#
#   brew install black-rainbow-labs/umbra/umbra
#
# packaging/release.ps1 writes Formula/umbra.rb in the tap from this file, with the version and
# the sha256 values read from the release's own SHA256SUMS, so no checksum is typed by hand.
class Umbra < Formula
  desc "Small coding agent for the terminal and for editors that speak ACP"
  homepage "https://github.com/Black-Rainbow-Labs/umbra"
  version "0.7.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Black-Rainbow-Labs/umbra/releases/download/v0.7.1/umbra-aarch64-apple-darwin.tar.gz"
      sha256 "fb4204d24872434d8bf8dedde7946fc6624441d47c1cd754e0f46179ad8bd094"
    end
    on_intel do
      url "https://github.com/Black-Rainbow-Labs/umbra/releases/download/v0.7.1/umbra-x86_64-apple-darwin.tar.gz"
      sha256 "771b7d6e4b172ba9509fbbf55e470964473159a08329e4ee83f4c325ee751db4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Black-Rainbow-Labs/umbra/releases/download/v0.7.1/umbra-aarch64-unknown-linux-musl.tar.gz"
      sha256 "21fe5d8071ef7ffee6acb2f4a849b86514989061e99ceb92cbbbbf606750c585"
    end
    on_intel do
      url "https://github.com/Black-Rainbow-Labs/umbra/releases/download/v0.7.1/umbra-x86_64-unknown-linux-musl.tar.gz"
      sha256 "d33dc54fe404b2115e76d97d1f33a488a94f54829b180b111e14f9fb0752c1e2"
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
