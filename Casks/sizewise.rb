cask "sizewise" do
  version "1.2.0"
  sha256 "fc35c288c9709cf5f5af05a4b54354875561590c53c95b6c33dbc301447e2560"

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
