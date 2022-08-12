create-package:
	@if [ -z $(node) ] || [ -z $(package) ]; then\
		echo "please give file node and package name. i.e. create-package node=my_node package=helloworld";\
	else\
		ros2 pkg create --build-type ament_python --node-name $(node) $(package)
	fi
