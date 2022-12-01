#!/bin/bash

set -x
{
    echo "source /opt/ros/humble/setup.zsh"
    echo "export DISPLAY=:0"
    echo "export ROS_VERSION=2"
    echo "export ROS_PYTHON_VERSION=3"
    echo "export ROS_DISTRO=humble"
    echo "export ROS_SECURITY_KEYSTORE=/workspaces/Modern_ROS2_Workspace/.ros_security/demo_keystore"
    echo "export ROS_SECURITY_ENABLE=true" # set to true if you need to enable ros2 security https://design.ros2.org/articles/ros2_dds_security.html
    echo "export ROS_SECURITY_ENCLAVE_OVERRIDE=/dev_environment_shared"
    echo "export ROS_SECURITY_STRATEGY=Enforce" # See https://design.ros2.org/articles/ros2_dds_security.html;
    #echo "export ROS_DOMAIN_ID=42" # See https://docs.ros.org/en/humble/Concepts/About-Domain-ID.html
    #echo "export ROS_LOCALHOST_ONLY=0"
    echo "echo 'ROS Environment'"
    echo "env | grep '^ROS_'"
}  >> ~/.zshrc

set -x
{
    echo "source /opt/ros/humble/setup.bash"
    echo "export DISPLAY=:0";
    echo "export ROS_VERSION=2"
    echo "export ROS_PYTHON_VERSION=3"
    echo "export ROS_DISTRO=humble"
    echo "export ROS_SECURITY_KEYSTORE=/workspaces/Modern_ROS2_Workspace/.ros_security/demo_keystore"
    echo "export ROS_SECURITY_ENABLE=true" # set to true if you need to enable ros2 security https://design.ros2.org/articles/ros2_dds_security.html
    echo "export ROS_SECURITY_ENCLAVE_OVERRIDE=/dev_environment_shared"
    echo "export ROS_SECURITY_STRATEGY=Enforce" # See https://design.ros2.org/articles/ros2_dds_security.html;
    #echo "export ROS_DOMAIN_ID=42" # See https://docs.ros.org/en/humble/Concepts/About-Domain-ID.html
    #echo "export ROS_LOCALHOST_ONLY=0"
    echo "echo 'ROS Environment'"
    echo "env | grep '^ROS_'"
}  >> ~/.bashrc

sudo apt update
sudo rosdep init
rosdep update -y
sudo apt install tcpdump

set +x

# Create ROS development keystore and enclaves
bash -c "cd ./.ros_security/ && source /opt/ros/humble/setup.bash && export ROS_VERSION=2 && ./create-demo-keystore.sh"
