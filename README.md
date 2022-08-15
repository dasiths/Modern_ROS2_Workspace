# Modern ROS2 Development Environment

This is an example of a modern ROS2 (Robot Operating System v2) development environment (Python) which utilises a devcontainer and integrated with VS Code debug, linting and testing.

This devcontainer is based on Jammy (Linux LTS 22.04) and ROS2 Humble Hawksbill distro. The repo is based on some best practices and information from the official [ROS2 doco](https://docs.ros.org/en/humble/index.html).

This repo also has some scripts and dockerfiles you can use for your CI pipeline. See the [Build](./build/README.md) folder.

**This repo will move to the AzureSamples org shortly as it can be better supported there.**

## Opinions

This repo contains a lot of opinions and they may or may not work for your specific scenario. This meant to be an example rather than an all encompassing template.

We heavily utilise makefiles for abstracting and running common tasks.

### Sourcing

We are using the bash profile (bashrc) and zsh profile to source the environment by default. This works for us because we have a clear separation of environments because of the devcontainer.

### Folder Structure And Creating New Packages

The packages are created under `src/ros/workspace`. Use the makefile create-package target (i.e. `make create-package node=helloworld package=mypackage`) to create new workspaces.

Once a new package is created, copy the makefile from the `talkerlistener` and implement the same targets. Those targets are used by the CI system.

### Linting

We didn't prefer `ament_flake8`, `ament_pep257` for linting. Instead we have Flake8 setup for the VS Code workspace and the `.flake8` file in the root of the repo controls the rules for the workspace as well as CI.

You can implement the [default linting rules](https://docs.ros.org/en/humble/The-ROS2-Project/Contributing/Code-Style-Language-Versions.html#id4) for ROS2 in Flake8 if required.

### Testing

You can use the `make test` target to run `colcon` test and return an exit code. This is useful for CI as it will generate the test results and coverage reports too.

VS Code test runner is integrated but it requires all the packages have been built (`make rosbuild`) or the test discovery service will crash. If it keeps crashing complaining of missing modules, restart VS Code and it will get resolved.

### Security

`SROS2` (ros2 security) has been implemented in this workspace and a `demo_keystore` gets created during the devcontainer post creation script. Update `.ros_security/create-demo-keystore.sh` with the security enclave for any new packages you require.

We utilise the `ROS_SECURITY_ENCLAVE_OVERRIDE` environment variable to set the security enclave as it's easier to set in a container rather than the `--rosargs --enclave="..."` approach.

Details about ROS2 DDS Security here <https://design.ros2.org/articles/ros2_dds_security.html>.

## Todo

- Introduce VS Code tasks to make makefile target discovery easier.
- Add sample using `launch` and reading `config` from environment.

## Notes

This repo contains some generic examples from the ROS2 github repos. The devcontainer, folder structure, make targets and example build pipeline are examples only. They have not been tested thoroughly.

Contributors:
- Dasith Wijesiriwardena
- Jordan Knight
- Juan Burckhardt
- Jason Goodsell
- Sunganya Srinivasan
