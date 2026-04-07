# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
#

class Codemark < Formula
  desc "A structural bookmarking system for code using tree-sitter queries"
  homepage "https://github.com/DanielCardonaRojas/codemark"
  url "https://github.com/DanielCardonaRojas/codemark/archive/refs/tags/0.3.0.tar.gz"
  sha256 "411295be92307701521d2941bd6b91dea52c10e05f9a8052b306dc16df0d9308"
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
