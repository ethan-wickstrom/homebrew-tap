cask "sizewise" do
  version "1.3.1"
  sha256 "c5eecb8d28d1e86a73a5102abd41393ade9e25ea79dfb4d0d3f89c02f724ac14"

  url "https://updates.getsizewise.app/Sizewise-#{version}.dmg"
  name "Sizewise"
  desc "Shows disk usage as a treemap and finds what takes up space"
  homepage "https://getsizewise.app/"

  livecheck do
    url "https://updates.getsizewise.app/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: :sequoia

  app "Sizewise.app"

  uninstall quit: "me.wickstrom.Sizewise"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/me.wickstrom.sizewise.sfl*",
    "~/Library/Application Support/me.wickstrom.Sizewise",
    "~/Library/Caches/me.wickstrom.Sizewise",
    "~/Library/HTTPStorages/me.wickstrom.Sizewise",
    "~/Library/Preferences/me.wickstrom.Sizewise.plist",
    "~/Library/Saved Application State/me.wickstrom.Sizewise.savedState",
  ]
end
