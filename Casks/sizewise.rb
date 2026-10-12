cask "sizewise" do
  version "1.4.0"
  sha256 "122dde2fde8872ee0dc6cd8343237a0c7243fe9648f669a180ee1c4e81b5d1f8"

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
