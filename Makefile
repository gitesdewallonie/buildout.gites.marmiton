#!/usr/bin/make
#
# Makefile for Debian
#
VERSION=`cat version.txt`

deb:
	gbp dch -a --ignore-branch -v
	dch -v $(VERSION).$(BUILD_NUMBER) release --no-auto-nmu
	dpkg-buildpackage -b -uc -us
	mv ../*.deb .

DEB=$(wildcard *.deb)
publish-deb: $(DEB)
	curl -F file=@$^ http://aptly-api.affinitic.be/api/files/$^
	curl -X POST http://aptly-api.affinitic.be/api/repos/stretch_production/file/$^
	curl -X POST -H 'Content-Type: application/json' --data '{"Distribution": "stretch", "SourceKind": "local", "Signing": {"Skip": true},"Sources": [{"Name": "stretch_production"}]}' http://aptly-api.affinitic.be/api/publish/repos

.PHONY: deb upgrade-db
