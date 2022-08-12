record-all-topics:
	@if [ -z $(file) ]; then\
		echo "please give file for the rosbag. i.e. make record-all-topics file=test";\
		echo "using default";\
		bash -c "cd ros_bags && ros2 bag record -a";\
	else\
		bash -c "cd ros_bags && ros2 bag record -o $(file) -a";\
	fi

record-topic:
	@if [ -z $(file) ] || [ -z $(topic) ]; then\
		echo "please give file name and topics(s) for the rosbag. i.e. make record-topic file=mybagname topic=topic1";\
	else\
		bash -c "cd ros_bags && ros2 bag record -o $(file) $(topic)";\
	fi

bag-info:
	@if [ -z $(file) ]; then\
		echo "please give file name for the rosbag. i.e. make bag-info file=test";\
	else\
		bash -c "cd ros_bags && ros2 bag info $(file)";\
	fi

bag-play:
	@if [ -z $(file) ]; then\
		echo "please give file name for the rosbag. i.e. make bag-play file=test";\
	else\
		bash -c "cd ros_bags && ros2 bag play $(file)";\
	fi

bag-play-loop:
	@if [ -z $(file) ]; then\
		echo "please give file name for the rosbag. i.e. make bag-play file=test";\
	else\
		bash -c "cd ros_bags && ros2 bag play -l $(file)";\
	fi

publish-topic:
	@if [ -z $(topic) ]; then\
		echo "please give file name for the topic. i.e. make publish-test-messages topic=/topic";\
	else\
		ros2 topic pub $(topic) std_msgs/String "data: Hello ROS Developers";\
	fi

listen-topic:
	@if [ -z $(topic) ]; then\
		echo "please give file name for the topic. i.e. make listen-topic topic=/topic";\
	else\
		ros2 topic echo $(topic);\
	fi
