from pathlib import Path
import sys
import launch
import launch_ros
import launch.actions
import pytest

import launch_pytest
from launch_pytest.tools import process as process_tools

# More examples here
# https://github.com/ros2/launch/tree/rolling/launch_pytest
# This is an example of how we write tests using laucnh_pytest

# After all these tests are done, the launch system will shut down the processes that it started up


@pytest.fixture
def listener_proc():
    path_to_test = Path(__file__).parent
    # Launch a process to test
    return launch_ros.actions.Node(
        executable=sys.executable,
        arguments=[
            str(path_to_test / "../talkerlistener" / "subscriber_member_function.py")
        ],
        # Need python unbuffering enabled for python logs and logging to direct to stout
        # https://docs.ros.org/en/humble/Tutorials/Demos/Logging-and-logger-configuration.html#default-stream-for-console-output
        additional_env={
            "PYTHONUNBUFFERED": "1",
            "RCUTILS_LOGGING_USE_STDOUT": "1",
        },
        name="demo_node_1",
        output="screen",
        cached_output=True
    )


@pytest.fixture()
def publisher_proc():
    return launch.actions.ExecuteProcess(
        cmd=[
            "ros2",
            'topic pub /topic std_msgs/String "data: Hello ROS Developers"',
        ],
        shell=True,
        cached_output=True,
    )


@launch_pytest.fixture
def launch_description(listener_proc, publisher_proc):

    return launch.LaunchDescription(
        [
            listener_proc,
            publisher_proc,
            launch_pytest.actions.ReadyToTest(),
        ]
    )


@pytest.mark.launch(fixture=launch_description)
def test_listener(listener_proc, publisher_proc, launch_context):
    def validate_output(output):
        assert 'Started listener' in output, 'process never printed expetcted output'
        assert 'I heard: "Hello ROS Developers"' in output, 'process never printed expetcted output'
    process_tools.assert_output_sync(
        launch_context, listener_proc, validate_output, timeout=5)

    def validate_output(output):
        return output == 'this will never happen'
    assert not process_tools.wait_for_output_sync(
        launch_context, listener_proc, validate_output, timeout=0.1)
    yield

    # this is executed after launch service shutdown
    assert listener_proc.return_code == -2
    assert publisher_proc.return_code == -15
