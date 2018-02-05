 # Makefile to build dnsmasq blacklist
 SHELL=/usr/bin/env bash

 # Go parameters
	EXECUTABLE=install-pkgs

# Executables
	GSED=$(shell which gsed || which sed) -i.bak -e

# Environment variables
	COPYRIGHT=s/Copyright © 20../Copyright © $(shell date +"%Y")/g
	COVERALLS_TOKEN=W6VHc8ZFpwbfTzT3xoluEWbKkrsKT1w25
	DATE=$(shell date -u '+%Y-%m-%d_%I:%M:%S%p')
	GIT=$(shell git rev-parse --short HEAD)
	LIC=LICENSE
	README=README.md
	OLDVER=$(shell cat ./OLDVERSION)
	VER=$(shell cat ./VERSION)
	BADGE=s/version-v$(OLDVER)-green.svg/version-v$(VER)-green.svg/g
	TAG="v$(VER)"

.PHONY: all clean copyright readme 
all: clean copyright readme 

.PHONY: build
build: clean copyright readme 

.PHONY: clean
clean:
	$(GOCLEAN)
	find . -o -name "*.tgz" -type f \
	| xargs rm 

.PHONY: copyright
copyright:
	$(GSED) '$(COPYRIGHT)' $(README)
	$(GSED) '$(COPYRIGHT)' $(LIC)


.PHONY: docs
docs: version

.PHONY: readme 
readme: version

.PHONY: tags
tags:
	git push origin --tags

.PHONY: version
version:
	$(GSED) '$(BADGE)' $(README)
	$(GSED) '$(RELEASE)' $(README)
	cmp -s VERSION OLDVERSION || cp VERSION OLDVERSION

.PHONY: release
release: all commit push
	@echo Released $(TAG)

.PHONY: commit
commit:
	@echo Committing release $(TAG)
	git commit -am"Release $(TAG)"
	git tag $(TAG)

.PHONY: push
push:
	@echo Pushing release $(TAG) to master
	git push --tags
	git push
