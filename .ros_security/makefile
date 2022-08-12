ROOT_DIR:=$(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

create-keystore:
	@if [ -z $(storename) ]; then\
		echo "please give pass key store name. e.g. make create-keystore storename=demo_keystore";\
	else\
		ros2 security create_keystore $(storename);\
	fi

create-enclave:
	@if [ -z $(storename) ] || [ -z $(enclave) ]; then\
		echo "please give store name and enclave name. i.e. make create-enclave storename=demo_keystore enclave=/talker_listener/talker";\
	else\
		ros2 security create_enclave $(storename) $(enclave);\
	fi
	