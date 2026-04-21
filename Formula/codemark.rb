# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
#

class Codemark < Formula
  desc "A structural bookmarking system for code using tree-sitter queries"
  homepage "https://github.com/DanielCardonaRojas/codemark"
  url "https://github.com/DanielCardonaRojas/codemark/archive/refs/tags/0.5.3.tar.gz"
  sha256 "9c96d5acbac5b1d0be39822d4179a3c0ad3f4ed2f2e3642275f379a82813abba"
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
