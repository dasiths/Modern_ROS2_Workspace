from pathlib import Path
import sys
import launch
import launch_ros
import launch.actions
import pytest

import launch_pytest

from threading import Event
from threading import Thread
import rclpy
from rclpy.node import Node
from std_msgs.msg import String

# More examples here
# https://github.com/ros2/launch/tree/rolling/launch_pytest
# This is an example of how we write tests using laucnh_pytest

# After all these tests are done, the launch system will shut down the processes that it started up


@pytest.fixture
def talker_proc():
    path_to_test = Path(__file__).parent
    # Launch a process to test
    return launch_ros.actions.Node(
        executable=sys.executable,
        arguments=[
            str(path_to_test / "../talkerlistener" / "publisher_member_function.py")
        ],
        additional_env={"PYTHONUNBUFFERED": "1"},
        name="demo_node_1",
        output="screen",
    )


@launch_pytest.fixture
def launch_description(talker_proc):

    return launch.LaunchDescription(
        [
            talker_proc,
            launch_pytest.actions.ReadyToTest(),
        ]
    )


@pytest.mark.launch(fixture=launch_description)
def test_talker(talker_proc, launch_context):
    rclpy.init()
    try:
        node = MakeTalkerNode("test_node")
        node.start_subscriber()
        msgs_received_flag = node.msg_event_object.wait(timeout=10.0)
        assert msgs_received_flag, "Did not receive msgs !"
    finally:
        rclpy.shutdown()
        yield

    # this is executed after launch service shutdown
    assert talker_proc.return_code == -2


class MakeTalkerNode(Node):
    def __init__(self, name="test_node"):
        super().__init__(name)
        self.msg_event_object = Event()

    def start_subscriber(self):
        # Create a subscriber
        self.subscription = self.create_subscription(
            String, "topic", self.subscriber_callback, 5
        )

        # Add a spin thread
        self.ros_spin_thread = Thread(
            target=lambda node: rclpy.spin(node), args=(self,)
        )
        self.ros_spin_thread.start()

    def subscriber_callback(self, data):
        print("messages recieved")
        self.msg_event_object.set()
