# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
#

class Codemark < Formula
  desc "A structural bookmarking system for code using tree-sitter queries"
  homepage "https://github.com/DanielCardonaRojas/codemark"
  url "https://github.com/DanielCardonaRojas/codemark/archive/refs/tags/0.7.0.tar.gz"
  sha256 "58589cbc60d65105b4c26a2817fa732e75083b000152bc8efc161cdde1e84aa0"
  license "MIT"

  depends_on "rust" => :build

  def install
    # Fix clap panic: non-required positional argument (repo) before required (server)
    inreplace "crates/codemark-cli/src/cli/mod.rs" do |s|
      s.gsub!(/pub struct RepoSetServerArgs \{(.*?)pub repo: Option<String>,(.*?)pub server: String,(.*?)\}/m,
              "pub struct RepoSetServerArgs {\\1pub server: String,\\2pub repo: Option<String>,\\3}")
    end

    # Generate man pages
    system "cargo", "run", "--manifest-path", "crates/codemark-cli/Cargo.toml", "--bin", "gen-man-pages", "--features", "man-pages"
    
    # Install codemark-cli
    system "cargo", "install", "--path", "crates/codemark-cli", "--features", "man-pages", "--no-default-features", *std_cargo_args
    
    # Install codemark-tui
    system "cargo", "install", "--path", "crates/codemark-tui", *std_cargo_args
    
    # Install man pages
    man1.install Dir["crates/codemark-cli/man/*.1"]
  end

  test do
    # Verify the binaries run
    assert_match "codemark", shell_output("#{bin}/codemark --version")
    assert_match "codemark-tui", shell_output("#{bin}/codemark-tui --version")
  end
end
