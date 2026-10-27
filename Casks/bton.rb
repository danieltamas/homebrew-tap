cask "bton" do
  version "0.10.0"
  sha256 "15e26a888d5d2106fddc81a8f44d5f4d097772fa2bfdbee6d12545520a66ae1b"

  url "https://github.com/danieltamas/bton/releases/download/v#{version}/Bton-#{version}.zip"
  name "Bton"
  desc "Runs a team's pull request flow and scheduled agents from the macOS menu bar"
  homepage "https://github.com/danieltamas/bton"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "Bton.app"
  binary "#{appdir}/Bton.app/Contents/MacOS/BtonCLI", target: "bton"

  # The app is signed ad hoc, not notarized. The curl installer leaves no quarantine flag, so the
  # app opens at once; the cask matches it instead of sending the user to System Settings.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Bton.app"],
                          writable_paths: ["Bton.app"], writable_base: :appdir
  end

  uninstall quit: "ro.danieltamas.bton"

  zap trash: [
    "~/.bton",
    "~/Library/Preferences/ro.danieltamas.bton.plist",
  ]

  caveats <<~EOS
    Bton drives GitHub through gh: brew install gh, then gh auth login.
    Bton updates itself from Settings, About. After such an update, run
    brew upgrade --cask danieltamas/tap/bton once so Homebrew's record matches.
  EOS
end
