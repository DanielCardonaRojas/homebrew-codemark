# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
#

class Codemark < Formula
  desc "A structural bookmarking system for code using tree-sitter queries"
  homepage "https://github.com/DanielCardonaRojas/codemark"
  url "https://github.com/DanielCardonaRojas/codemark/archive/refs/tags/0.7.1.tar.gz"
  sha256 "3338bafd8490a1fc5bfc79544d8ec3a0f1cc4ae1d6479bf8b96fbb3e02bf5eb4"
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
    system "cargo", "install", *std_cargo_args(path: "crates/codemark-cli"),
           "--features", "man-pages", "--no-default-features"

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
