.ONESHELL:

TAG:=`cat VERSION`

build:
	@docker build . -f Dockerfile --tag registry.gitlab.com/ska-telescope/src/ska-rucio-prototype/ska-src-storm-webdav:$(TAG)

push: build
	@docker push registry.gitlab.com/ska-telescope/src/ska-rucio-prototype/ska-src-storm-webdav:$(TAG)

run: build
	@docker run -it registry.gitlab.com/ska-telescope/src/ska-rucio-prototype/ska-src-storm-webdav:$(TAG)

run-no-start: build 
	@docker run -it --entrypoint /bin/bash registry.gitlab.com/ska-telescope/src/ska-rucio-prototype/ska-src-storm-webdav:$(TAG)
