#!/bin/bash

make create-keystore storename=demo_keystore

# The default one used for ROS2 CLI
make create-enclave storename=demo_keystore enclave=/dev_environment_shared

# Node specific envlaves
make create-enclave storename=demo_keystore enclave=/talker_listener/listener
make create-enclave storename=demo_keystore enclave=/talker_listener/talker
