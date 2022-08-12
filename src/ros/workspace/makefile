create-package:
	@if [ -z $(node) ] || [ -z $(package) ]; then\
		echo "please give file node and package name. i.e. make create-package node=helloworld package=mypackage";\
	else\
		ros2 pkg create --build-type ament_python --node-name $(node) $(package);\
	fi
