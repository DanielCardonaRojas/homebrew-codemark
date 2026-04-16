# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
#

class Codemark < Formula
  desc "A structural bookmarking system for code using tree-sitter queries"
  homepage "https://github.com/DanielCardonaRojas/codemark"
  url "https://github.com/DanielCardonaRojas/codemark/archive/refs/tags/0.5.0.tar.gz"
  sha256 "2bdfc0f5385ebca4e8a9e6b898823a2b6955b8d39860fe6e5bce02f07102f6cd"
  license "MIT"

  depends_on "rust" => :build

  def install
    # Generate man pages first
    system "cargo", "run", "--bin", "gen-man-pages", "--features", "man-pages"
    # Install the binary
    system "cargo", "install", "--features", "man-pages", "--no-default-features", *std_cargo_args
    # Install man pages
    man1.install Dir["man/*.1"]
  end

  test do
    # Verify the binary runs
    assert_match "codemark", shell_output("#{bin}/codemark --version")
    # Test that help works
    assert_match "add", shell_output("#{bin}/codemark --help")
  end
end
