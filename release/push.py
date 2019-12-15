#!/usr/local/bin/python3

from github import Github
from configparser import ConfigParser
import os
import sys

selfpath = os.path.dirname(sys.argv[0])
config = ConfigParser()
config.read(os.path.join(selfpath, "config.ini"))

g = Github(config['github']['token'])

repo = g.get_organization("nova-video-player").get_repo("aos-AVP")

print(repo.name)

#changelog is in whatsnew
with open('../../Video/src/noamazon/play/release-notes/en-US/internal.txt', 'r') as whatsnew:
    changelog=whatsnew.read()
#    changelog=whatsnew.read().replace('^', '- ')
#    changelog=whatsnew.read().replace('\n', '')

#create_git_release(tag, name, message, draft=False, prerelease=False, target_commitish=NotSet)
release = repo.create_git_release(sys.argv[1], sys.argv[2], changelog, draft = True)
folder = sys.argv[3]
print("Made release " + str(release))
for f in os.listdir(folder):
    path = os.path.join(folder, f)
    if not os.path.isfile(path):
        continue
    if f.endswith(".apk"):
        release.upload_asset(path)
    if f.endswith("manifest.xml"):
        release.upload_asset(path)
