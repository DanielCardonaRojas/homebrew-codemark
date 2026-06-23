# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
#

class Codemark < Formula
  desc "A structural bookmarking system for code using tree-sitter queries"
  homepage "https://github.com/DanielCardonaRojas/codemark"
  url "https://github.com/DanielCardonaRojas/codemark/archive/refs/tags/0.7.12.tar.gz"
  sha256 "49fd9e94cdfbb8eb9b21bde38d915fbea967c17c146bf0d761b7b8390168ee0d"
  license "MIT"

  depends_on "rust" => :build

  def install
    # Generate man pages
    system "cargo", "run", "--manifest-path", "crates/codemark-cli/Cargo.toml", "--bin", "gen-man-pages", "--features", "man-pages"
    
    # Install codemark-cli
    system "cargo", "install", "--no-default-features",
           *std_cargo_args(path: "crates/codemark-cli", features: "man-pages")

    # Install codemark-tui
    system "cargo", "install", *std_cargo_args(path: "crates/codemark-tui")
    
    # Install man pages
    man1.install Dir["crates/codemark-cli/man/*.1"]
  end

  test do
    # Verify the binaries run
    assert_match "codemark", shell_output("#{bin}/codemark --version")
    assert_match "codemark-tui", shell_output("#{bin}/codemark-tui --version")
  end
end
