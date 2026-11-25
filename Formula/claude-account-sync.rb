class ClaudeAccountSync < Formula
  include Language::Python::Shebang

  desc "Sync Claude desktop Code sessions and scheduled tasks between accounts"
  homepage "https://github.com/NiekNijland/claude-desktop-account-sync"
  url "https://github.com/NiekNijland/claude-desktop-account-sync/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "9b273933c0aa6e448c170afa78409a073cb160946652a8beafcc45e44f78c9bd"
  license "MIT"

  depends_on :macos
  depends_on "python@3.13"

  def install
    rewrite_shebang python_shebang_rewrite_info(formula_opt_bin("python@3.13")/"python3.13"), "claude-account-sync"
    bin.install "claude-account-sync"
  end

  service do
    run [opt_bin/"claude-account-sync", "--schedules"]
    run_type :interval
    interval 60
    log_path "#{Dir.home}/Library/Logs/claude-account-sync.log"
    error_log_path "#{Dir.home}/Library/Logs/claude-account-sync.log"
  end

  def caveats
    <<~EOS
      Sign in with both accounts in the Claude desktop app first, then see what
      would change:
        claude-account-sync check
      Start the sync (every minute, sessions and scheduled tasks):
        brew services start claude-account-sync
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude-account-sync --version")
  end
end
