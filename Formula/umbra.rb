# The Homebrew formula for the tap Black-Rainbow-Labs/homebrew-umbra.
#
#   brew install black-rainbow-labs/umbra/umbra
#
# packaging/release.ps1 writes Formula/umbra.rb in the tap from this file, with the version and
# the sha256 values read from the release's own SHA256SUMS, so no checksum is typed by hand.
class Umbra < Formula
  desc "Small coding agent for the terminal and for editors that speak ACP"
  homepage "https://github.com/Black-Rainbow-Labs/umbra"
  version "0.6.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Black-Rainbow-Labs/umbra/releases/download/v0.6.0/umbra-aarch64-apple-darwin.tar.gz"
      sha256 "3b6fccb2fc628e79922efd3f5f7e14c2adbe151f8cbc12e6d06a12b31d0b3d6d"
    end
    on_intel do
      url "https://github.com/Black-Rainbow-Labs/umbra/releases/download/v0.6.0/umbra-x86_64-apple-darwin.tar.gz"
      sha256 "2f4ce534e9e30d0792aab779c8a4636e2d38fdb5ebf39e43c1069bc94b521498"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Black-Rainbow-Labs/umbra/releases/download/v0.6.0/umbra-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7127e6c5ae69fd94b1475a533011ce1be7bd309d81f24481862b9f58c9e2cf52"
    end
    on_intel do
      url "https://github.com/Black-Rainbow-Labs/umbra/releases/download/v0.6.0/umbra-x86_64-unknown-linux-musl.tar.gz"
      sha256 "742fedcfa23af845a37faeec8987f0ace873af7f0569fc42b8a9f1947d785777"
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
