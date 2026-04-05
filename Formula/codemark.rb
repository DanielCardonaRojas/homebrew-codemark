# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
#

class Codemark < Formula
  desc "A structural bookmarking system for code using tree-sitter queries"
  homepage "https://github.com/DanielCardonaRojas/codemark"
  url "https://github.com/DanielCardonaRojas/codemark/archive/refs/tags/0.2.0.tar.gz"
  sha256 "d5754496e95f8ab3ffe7485553fa4dc3fcd46945685485b1512cbe94970d8d78"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  test do
    # Verify the binary runs
    assert_match "codemark", shell_output("#{bin}/codemark --version")
    # Test that help works
    assert_match "add", shell_output("#{bin}/codemark --help")
  end
end
