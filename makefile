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

lint-all:
	flake8 --append-config=.flake8 .

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

# The ports in use are listed here
# - https://docs.ros.org/en/humble/Concepts/About-Domain-ID.html#domain-id-to-udp-port-calculator
# - http://docs.ros.org/en/rolling/Tutorials/Advanced/Security/Examine-Traffic.html#display-encrypted-discovery-packets
inspect-discovery-packets:
	sudo tcpdump -X -i any udp port 7400

inspect-data-packets:
	sudo tcpdump -i any -X udp portrange 7401-7500
