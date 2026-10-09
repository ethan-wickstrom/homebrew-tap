import email.utils
import hashlib
import os
import re
import urllib.request
import xml.etree.ElementTree as ET
from datetime import datetime, timedelta, timezone

APPCAST = "https://updates.getsizewise.app/appcast.xml"
CASK = "Casks/sizewise.rb"
SPARKLE = "{http://www.andymatuschak.org/xml-namespaces/sparkle}"
HOLD = timedelta(hours=float(os.environ.get("HOLD_HOURS", "3")))


def fetch(url):
    request = urllib.request.Request(url, headers={"User-Agent": "sizewise-homebrew-tap"})
    with urllib.request.urlopen(request, timeout=300) as response:
        return response.read()


def version_key(version):
    return tuple(int(part) for part in version.split("."))


def released(now):
    for item in ET.fromstring(fetch(APPCAST)).iter("item"):
        enclosure = item.find("enclosure")
        version = item.findtext(f"{SPARKLE}shortVersionString")
        if not version and enclosure is not None:
            version = enclosure.get(f"{SPARKLE}shortVersionString")
        published = item.findtext("pubDate")
        if not version or not published or not re.fullmatch(r"\d+(\.\d+)*", version.strip()):
            continue
        if now - email.utils.parsedate_to_datetime(published) >= HOLD:
            yield version.strip()


def main():
    versions = sorted(set(released(datetime.now(timezone.utc))), key=version_key)
    if not versions:
        print(f"The appcast has no release out for {HOLD}, so the cask stays as it is.")
        return
    version = versions[-1]
    with open(CASK) as file:
        cask = file.read()
    current = re.search(r'^  version "([^"]+)"$', cask, re.M).group(1)
    if version == current:
        print(f"The cask already installs {version}.")
        return
    digest = hashlib.sha256(fetch(f"https://updates.getsizewise.app/Sizewise-{version}.dmg")).hexdigest()
    cask = re.sub(r'^  version "[^"]+"$', f'  version "{version}"', cask, count=1, flags=re.M)
    cask = re.sub(r'^  sha256 "[0-9a-f]{64}"$', f'  sha256 "{digest}"', cask, count=1, flags=re.M)
    with open(CASK, "w") as file:
        file.write(cask)
    print(f"The cask now installs {version}, with SHA-256 {digest}. It installed {current}.")
    with open(os.environ.get("GITHUB_OUTPUT", os.devnull), "a") as output:
        output.write(f"version={version}\n")


if __name__ == "__main__":
    main()
