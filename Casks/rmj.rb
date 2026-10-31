cask "rmj" do
  version "0.8.1"
  sha256 "e6ff6c4ed65f07a489f6258aec5e5f622ffaf1c09486b10312941058bef14e32"

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
