build-%: clean-%
	cd src/ros/workspace/$* &&\
	make rosbuild

run-%:
	cd src/ros/workspace/$* &&\
	make run

clean-%:
	cd src/ros/workspace/$* &&\
	make cleanup

test-%:
	cd src/ros/workspace/$* &&\
	make test

lint:
	flake8 .

local-build-all:
	echo building multiple containers;\
	./build/package/build.sh $(version)

local-setup-test:
	echo building all the packages and resolving dependencies used for test discovery;\
	./build/package/build-all.sh

ci-test-all:
	echo testing multiple containers;\
	./build/package/test.sh

ci-push-all:
ifndef REGISTRY
	@echo "REGISTRY not defined, export REGISTRY=your-registry.azurecr.io/"
	@exit 1
else
	./build/package/push.sh $(REGISTRY) $(version)
endif
