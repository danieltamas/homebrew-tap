cask "agencil" do
  version "0.8.0"
  sha256 "2527d0ed6d547d027ac3174552d1090b66ea974bed0fcca654cfca1c40ac5075"

  url "https://github.com/danieltamas/agencil/releases/download/v#{version}/Agencil-#{version}-adhoc.zip"
  name "Agencil"
  desc "Councils of coding agents: ask any seat, get a recorded verdict"
  homepage "https://github.com/danieltamas/agencil"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "Agencil.app"
  binary "#{appdir}/Agencil.app/Contents/Resources/agencil"

  # The app is signed ad hoc, not notarized. The curl installer leaves no quarantine flag, so the
  # app opens at once; the cask matches it instead of sending the user to System Settings.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Agencil.app"],
                          writable_paths: ["Agencil.app"], writable_base: :appdir
  end

  uninstall quit: "ro.danieltamas.agencil"

  zap trash: [
    "~/.agencil",
    "~/Library/Preferences/ro.danieltamas.agencil.plist",
  ]

  caveats <<~EOS
    Agencil updates itself from Settings, About. After such an update, run
    brew upgrade --cask danieltamas/tap/agencil once so Homebrew's record matches.
  EOS
end
