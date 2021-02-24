.PHONY: build

build:
	mix do deps.get, escript.build

build_alpine:
	docker build -t test-results-alpine -f dockerfiles/Dockerfile.alpine .
	docker create -ti --name dummy test-results-alpine bash
	docker cp dummy:/build/result_parser ./bin/test-results-alpine
	$(MAKE) clean

build_ubuntu1804:
	docker build -t test-results-ubuntu18 -f dockerfiles/Dockerfile.ubuntu18 .
	docker run -it test-results-ubuntu18 /bin/bash
	# docker create -ti --name dummy test-results-ubuntu18 bash
	# docker cp dummy:/build/result_parser ./bin/test-results-ubuntu18
	# $(MAKE) clean

clean:
	docker rm -f dummy