# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
#

class Codemark < Formula
  desc "A structural bookmarking system for code using tree-sitter queries"
  homepage "https://github.com/DanielCardonaRojas/codemark"
  url "https://github.com/DanielCardonaRojas/codemark/archive/refs/tags/0.5.2.tar.gz"
  sha256 "5dbd67eb9d33d15fb0efcc2a89235b85c8c1ca4479619658c148e6200887e647"
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
