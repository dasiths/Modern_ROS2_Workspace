# Modern ROS2 Development Environment

This is an example of a modern ROS2 (Robot Operating System v2) development environment (Python) which utilises a devcontainer and integrated with VS Code debug, linting and testing.

The repo is based on best practices and information from the official [ROS2 doco](https://docs.ros.org/en/humble/index.html).

This repo also has some scripts and dockerfiles you can use for your CI pipeline. See the [Build](./build/README.md) folder.

## Folder Structure, Opinions And Creating New Packages

The packages are created under `src/ros/workspace`. Use the makefile create-package target (i.e. `make create-package node=helloworld package=mypackage`) to create new workspaces.

Once a new package is created, copy the makefile from the `talkerlistener` and implement the same targets. Those targets are used by the CI system.

## Linting

`ament_flake8`, `ament_pep257` are not preffered for linting. Instead we have Flake8 setup for the VS Code workspace and the `.flake8` file in the root of the repo controls the rules for the workspace as well as CI.

## Testing

You can use the `make test` target to run colcon test and return an exit code. This is useful for CI as it will generate the test results and coverage reports too.

VS Code test runner is integrated but it requires all the packages have been built (`make rosbuild`) or the test discovery service will crash. If it keeps crashing complaining of missing modules, restart VS Code and it will get resolved.

## Security

`SROS2` (ros2 security) has been implemented in this workspace and a `demo_keystore` gets created during the  devcontainer post creation script. Update `.ros_security/create-demo-keystore.sh` with the security envlave for any new packages you require.

We utilise the `ROS_SECURITY_ENCLAVE_OVERRIDE` envrionment variable to set the security enclave as it's easier to set in a container rather than the `--rosargs --enclave="..."` approach.

Details about ROS2 DDS Security here <https://design.ros2.org/articles/ros2_dds_security.html>.
