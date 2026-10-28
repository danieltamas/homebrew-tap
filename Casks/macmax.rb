cask "macmax" do
  version "0.3.0"
  sha256 "42a8848e4a9622f8b3cdda409721252c2b03c8a8a109229af2994d54ddaf0d38"

  url "https://github.com/danieltamas/macmax/releases/download/v#{version}/MacMax-#{version}.zip"
  name "MacMax"
  desc "Why your computer is slow: per-app CPU, memory, disk, network, safe cleanup"
  homepage "https://github.com/danieltamas/macmax"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "MacMax.app"
  binary "#{appdir}/MacMax.app/Contents/Resources/macmax"

  # The app is signed ad hoc, not notarized. The curl installer leaves no quarantine flag, so the
  # app opens at once; the cask matches it instead of sending the user to System Settings.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/MacMax.app"],
                          writable_paths: ["MacMax.app"], writable_base: :appdir
  end

  uninstall quit: "ro.danieltamas.macmax"

  zap trash: [
    "~/.macmax",
    "~/Library/Preferences/ro.danieltamas.macmax.plist",
  ]

  caveats <<~EOS
    MacMax updates itself from Settings, About. After such an update, run
    brew upgrade --cask danieltamas/tap/macmax once so Homebrew's record matches.
  EOS
end
