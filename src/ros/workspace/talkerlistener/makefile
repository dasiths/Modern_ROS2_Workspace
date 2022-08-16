package := talkerlistener

deps:
	rosdep install -i --from-path . --rosdistro humble -y --reinstall

rosbuild: deps
	colcon build --packages-select $(package)

run: cleanup rosbuild
# When running in a container, you can set TALKER_LISTENER_ROS_SECURITY_ENCLAVE_OVERRIDE env variable to point to the mounted enclave.
	@if [ -z $(action) ]; then\
		echo "please give pass action type (listener/talker). e.g. make run action=listener";\
		echo "defaulting to listener";\
		export ROS_SECURITY_ENCLAVE_OVERRIDE=/talker_listener/listener;\
		if [! -z $$TALKER_LISTENER_ROS_SECURITY_ENCLAVE_OVERRIDE ]; then\
			export ROS_SECURITY_ENCLAVE_OVERRIDE=/talker_listener/listener;\
		fi;\
		echo "Using security enclave: $$ROS_SECURITY_ENCLAVE_OVERRIDE with ROS_SECURITY_ENABLE=$$ROS_SECURITY_ENABLE";\
		bash -c ". install/setup.bash && ros2 run talkerlistener listener";\
	else\
		if [ "$(action)" = "talker" ]; then\
			export ROS_SECURITY_ENCLAVE_OVERRIDE=/talker_listener/talker;\
		else\
			export ROS_SECURITY_ENCLAVE_OVERRIDE=/talker_listener/listener;\
		fi;\
		if [! -z $$TALKER_LISTENER_ROS_SECURITY_ENCLAVE_OVERRIDE ]; then\
			export ROS_SECURITY_ENCLAVE_OVERRIDE=$$TALKER_LISTENER_ROS_SECURITY_ENCLAVE_OVERRIDE;\
		fi;\
		echo "Using security enclave: $$ROS_SECURITY_ENCLAVE_OVERRIDE with ROS_SECURITY_ENABLE=$$ROS_SECURITY_ENABLE";\
		bash -c ". install/setup.bash && ros2 run talkerlistener $(action)";\
	fi

cleanup:
	-echo removing old build packages &&\
	sudo rm -r build &&\
	sudo rm -r install &&\
	sudo rm -r log

test: rosbuild
	echo "running ros2 doctor"
	ros2 doctor --report
	echo "running tests"
	colcon test --pytest-with-coverage --event-handlers compile_commands+ console_cohesion+ console_direct+ console_package_list+ console_start_end+ console_stderr+ desktop_notification+ event_log+ log+ log_command+ status+ store_result+ summary+ terminal_title-
	echo "copying test results"
	sudo mkdir -p /test-results
	sudo cp build/$(package)/pytest.xml /test-results/result-$(package).xml
	sudo cp build/$(package)/coverage.xml /test-results/coverage-$(package).xml
	echo "returning test result exit code"
# make sure colcon test-result is the last command. It returns the exit code used by the CI pipeline.
	colcon test-result
