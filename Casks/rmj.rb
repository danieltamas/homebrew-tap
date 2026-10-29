cask "rmj" do
  version "0.3.0"
  sha256 "1250698d5990dbe135934ca11095b65a8b565aa6b36923fb658327c13953c986"

  url "https://github.com/danieltamas/runmyjob/releases/download/v#{version}/RMJ-#{version}.zip"
  name "RMJ"
  desc "Run My Job: routes builds and tests to your Tailscale boxes and tracks every run"
  homepage "https://github.com/danieltamas/runmyjob"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "RMJ.app"
  binary "#{appdir}/RMJ.app/Contents/Resources/rmj"

  # The app is signed ad hoc, not notarized. The curl installer leaves no quarantine flag, so the
  # app opens at once; the cask matches it instead of sending the user to System Settings.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/RMJ.app"],
                          writable_paths: ["RMJ.app"], writable_base: :appdir
  end

  uninstall quit: "ro.danieltamas.rmj"

  zap trash: [
    "~/.rmj",
    "~/Library/Preferences/ro.danieltamas.rmj.plist",
  ]
end
